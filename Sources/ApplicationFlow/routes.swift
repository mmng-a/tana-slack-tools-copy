import BlockKitBuilder
import Fluent
import Foundation
import Vapor
import SlackClient

func routes(_ routes: some RoutesBuilder) throws {
  
  let slackApp = SlackApp(routes)
  configureOpenNewAppModal(slackApp)
  configureActions(slackApp)
  configureForceActions(slackApp)
  configureHomeTabStateActions(slackApp)
  configureHomeTabPaginations(slackApp)
  
  configureExtAppRegister(slackApp)
  
  routes.post("event") { req async throws -> Response in
    if let challenge = try? req.content.get(String.self, at: "challenge") {
      return Response(body: .init(string: challenge))
    }
    let payload = try req.content.decode(EventPayload.self)
    switch payload.event {
    case .appHomeOpened(let event) where event.tab == .home:
      req.logger.log(level: .info, "home tab opened by \(event.user)")
      let user = try await TanaUser.find(event.user, on: req.db) ?? TanaUser(id: event.user)
      try await updateHomeTab(req, for: user)
    case .appHomeOpened(let event) where event.tab == .messages:
      req.logger.log(level: .info, "message tab opened by \(event.user)")
    case .workflowStepExecute(let workflowStepExecute):
      guard let userID = workflowStepExecute.event.workflowStep.inputs["user"] else {
        throw Abort(.internalServerError)
      }
      let triggerID = workflowStepExecute.event.workflowStep.workflowStepExecuteID
      try await openNewAppModal(req, triggerID: triggerID, userID: UserID(userID))
    default:
      break
    }
    return Response(status: .ok)
  }
  
  let encoder = JSONEncoder()
  
  routes.group("command") { command in
    command.post("open-drive") { req async throws in
      return openDriveMessage()
    }
  }
  
  routes.group("config") { config in
    config.post("update-team-execution") { req async throws in
//      let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
//      let list = try await slackClient.usergroupsUsersList(UserGroupID.teamExecution.rawValue)
//      UserGroup.teamExecution = list
      
      var headers = HTTPHeaders()
      headers.contentType = .json
      headers.bearerAuthorization = .slackBotAutorization
      let id = UserGroupID.teamExecution.rawValue
      let uri = URI("https://slack.com/api/usergroups.users.list?usergroup=\(id)")
      return try await req.client.get(uri, headers: headers)
    }
  }
}


func configureActions(_ slackApp: SlackApp) {
  slackApp.onBlockAction(blockID: "view-actions", actionID: "next") { req, blockAction -> Void in
    guard let ts = blockAction.message?.ts else { throw Abort(.badRequest) }
    try await onAction(req, ts: ts, user: blockAction.user.id, action: .next, triggerID: blockAction.triggerID)
  }
  slackApp.onBlockAction(blockID: "thread-actions", actionID: "next") { req, blockAction -> Void in
    guard let ts = blockAction.message?.threadTS else { throw Abort(.badRequest) }
    try await onAction(req, ts: ts, user: blockAction.user.id, action: .next, triggerID: blockAction.triggerID)
  }
  slackApp.onBlockAction(blockID: "thread-actions", actionID: "revert") { req, blockAction -> Void in
    guard let ts = blockAction.message?.threadTS else { throw Abort(.badRequest) }
    try await onAction(req, ts: ts, user: blockAction.user.id, action: .revert, triggerID: blockAction.triggerID)
  }
  slackApp.onBlockAction(blockID: "thread-actions", actionID: "change-number") { req, blockAction in
    guard let ts = blockAction.message?.threadTS else { throw Abort(.badRequest) }
    try await openChangeNumberModal(req, ts: ts, triggerID: blockAction.triggerID)
  }
  slackApp.onViewSubmission("change-number-modal") { req, viewSubmission in
    return try await onNumberChanged(req, viewSubmission: viewSubmission)
  }
  slackApp.onBlockAction(blockID: "section-with-overflow", actionID: "extra-action") { req, blockAction -> Void in
    guard let ts = blockAction.message?.ts,
          let action = blockAction.actions.first,
          case .overflow(let overflow) = action,
          let rawValue = Int(overflow.selectedOption.value),
          let newState = State(rawValue: rawValue) else { throw Abort(.internalServerError) }
    try await onAction(req, ts: ts, user: blockAction.user.id, action: .skipTo(newState), triggerID: blockAction.triggerID)
  }
}

func configureForceActions(_ slackApp: SlackApp) {
  func doForceAction(_ req: Request, _ viewSubmission: InteractionPayload.ViewSubmission, action: State.Action) async throws {
    let ts = viewSubmission.view.private_metadata
    try await onForceAction(req, ts: ts, user: viewSubmission.user.id, action: action)
  }
  slackApp.onViewSubmission("next-tapped-by-not-checker") { req, viewSubmission in
    try await doForceAction(req, viewSubmission, action: .next)
  }
  slackApp.onViewSubmission("revert-tapped-by-not-checker") { req, viewSubmission in
    try await doForceAction(req, viewSubmission, action: .revert)
  }
  for state in [State.cancelled, .chiefChecking, .exectionUnitChecking, .subrepresentativeChecking, .submitted] {
    slackApp.onViewSubmission("skipto-\(state.rawValue)-tapped-by-not-checker") { req, viewSubmission in
      try await doForceAction(req, viewSubmission, action: .skipTo(state))
    }
  }
}

func configureHomeTabStateActions(_ slackApp: SlackApp) {
  slackApp.onBlockAction(blockID: "home-tab-state", actionID: "category") { req, blockAction -> Void in
    guard let value = blockAction.view?.state.values["home-tab-state"]?["category"],
          case .staticSelect(.some(let option)) = value,
          let category = HomeTabState.Category(rawValue: option.value) else { throw Abort(.badRequest) }
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    user.homeTabState.category = category
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
  slackApp.onBlockAction(blockID: "home-tab-state", actionID: "show-sections-config") { req, blockAction in
    guard let action = blockAction.actions.first else { return }
    guard case .staticSelect(let staticSelect) = action else { throw Abort(.internalServerError) }
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    switch staticSelect.selectedOption.value {
    case "all": user.homeTabState.showAllSections = true
    case "selected": user.homeTabState.showAllSections = false
    default: throw Abort(.badRequest)
    }
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
  slackApp.onBlockAction(blockID: "home-tab-state", actionID: "sections") { req, blockAction -> Void in
    guard blockAction.view?.callback_id == "home-tab",
          let value = blockAction.view?.state.values["home-tab-state"]?["sections"],
          case .staticSelect(.some(let option)) = value,
          let section = TanaSectionName(rawValue: option.value) else { throw Abort(.badRequest) }
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    if user.homeTabState.sections.contains(section) {
      user.homeTabState.sections.remove(section)
    } else {
      user.homeTabState.sections.insert(section)
    }
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
  
  slackApp.onBlockAction(blockID: nil, actionID: "view-thread") { _, _ in }
}

func configureHomeTabPaginations(_ slackApp: SlackApp) {
  slackApp.onBlockAction(blockID: "home-pagenation", actionID: "next") { req, blockAction -> Void in
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    user.homeTabState.page += 1
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
  slackApp.onBlockAction(blockID: "home-pagenation", actionID: "back") { req, blockAction -> Void in
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    user.homeTabState.page -= 1
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
  slackApp.onBlockAction(blockID: "home-pagenation", actionID: "setto") { req, blockAction -> Void in
    guard let action = blockAction.actions.first,
          case .staticSelect(let staticSelect) = action,
          let value = Int(staticSelect.selectedOption.value) else { throw Abort(.badRequest) }
    let user = try await TanaUser.find(blockAction.user.id, on: req.db) ?? TanaUser(id: blockAction.user.id)
    user.homeTabState.page = value
    try await user.save(on: req.db)
    try await updateHomeTab(req, for: user)
  }
}
