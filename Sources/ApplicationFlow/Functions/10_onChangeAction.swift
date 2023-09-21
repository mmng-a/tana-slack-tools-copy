import BlockKitBuilder
import Foundation
import Fluent
import SlackClient
import Vapor

func onAction(_ req: Request, ts: String, user: UserID, action: State.Action, triggerID: String) async throws {
  let flow = try await getFlow(req, ts: ts)
  
  let isExecutive = UserGroup.executive.userIDs.contains(user)
  let isCheckingUser = flow.checkingUserIDs.contains(user)
  let isAuthores = flow.applicantUserID == user || flow.coAuthores.contains(user)
  let isChecking = [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(flow.state)
  let isRevisioning = [.revisioning1, .revisioning2, .cancelled].contains(flow.state)
  
  if isExecutive || (isChecking && isCheckingUser) || (isRevisioning && isAuthores) {
    try await doActionAndSendMessage(req, flow: flow, user: user, action: action)
  } else {
    let newState = flow.state.newState(after: action)
    let callbackID: String
    do {
      switch action {
      case .next:  callbackID = "next-tapped-by-not-checker"
      case .revert: callbackID = "revert-tapped-by-not-checker"
      case .skipTo: callbackID = "skipto-\(newState.rawValue)-tapped-by-not-checker"
      }
    }
    let submissionText, body: String
    if newState == .cancelled {
      submissionText = "取消"
      body = "あなたは提出者ではありません。\n本当に\(flow.title)の提出を取り消しますか。"
    } else if case .skipTo = action {
      submissionText = "変更"
      body = "本当に\(flow.title)を\(newState)に変更しますか。"
    } else if [.revisioning1, .revisioning2].contains(flow.state) && action == .next {
      submissionText = "修正完了"
      body = "あなたは提出者ではありません。\n本当に\(flow.title)の修正を完了しましたか。"
    } else if [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(flow.state) && action == .next {
      submissionText = "チェック完了"
      body = "あなたは現在のチェッカーではありません。\n本当に\(flow.title)の\(flow.state)を完了しますか。"
    } else if [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(flow.state) && action == .revert {
      submissionText = "差し戻し"
      body = "あなたは現在のチェッカーではありません。\n本当に\(flow.title)の\(flow.state)を差し戻しますか。"
    } else if flow.state == .writingNumber && action == .next {
      submissionText = "記入完了"
      body = "あなたは現在のチェッカーではありません。\n本当に申請書No.を記入しましたか。"
    } else {
      submissionText = "変更"
      body = "本当に\(flow.title)を\(newState)に変更しますか。"
    }
    
    var modal = Modal(callbackID, title: "確認", submit: PlainText(submissionText), close: "キャンセル") {
      Section(.markdown(body))
      ContextBlock { Markdown("_なお、この操作は取り消せます。_") }
    }
    
    modal.privateMetadata = ts
    let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
    try await slackClient.viewsOpen(triggerID: triggerID, view: modal)
  }
}

func onForceAction(_ req: Request, ts: String, user: UserID, action: State.Action) async throws {
  let flow = try await getFlow(req, ts: ts)
  try await doActionAndSendMessage(req, flow: flow, user: user, action: action)
}

func getFlow(_ req: Request, ts: String) async throws -> ApplicationFlow {
  guard let flow = try await req.db.query(ApplicationFlow.self)
    .filter(\.$threadTS == ts)
    .first() else {
    
    throw Abort(.internalServerError)
  }
  return flow
}

fileprivate func doActionAndSendMessage(
  _ req: Request, flow: ApplicationFlow, user: UserID, action: State.Action
) async throws {
  if case .skipTo(let newState) = action, newState == flow.state {
    return
  }
  let oldState = flow.state
  flow.state.doAction(action)
  
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  let sendingThreadMessages = Task {
    let text: String
    if flow.state == .cancelled {
      text = "\(user)が提出を取り消しました。"
    } else if flow.state == .submitted {
      text = "\(user)がSLに提出しました。"
    } else if case .skipTo(let state) = action {
      text = "\(user)が\(oldState)を\(state)に変更しました。"
    } else if oldState == .cancelled && action == .next {
      text = "\(user)が再提出しました。"
    } else if [.revisioning1, .revisioning2].contains(oldState) && action == .next {
      text = "\(user)が修正を完了しました。"
    } else if [.revisioning1, .revisioning2].contains(flow.state) && action == .revert {
      text = "\(user)が\(oldState)を差し戻しました。"
    } else if [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(oldState) && action == .next {
      text = "\(user)が\(oldState)を完了しました。"
    } else if [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(flow.state) && action == .revert {
      text = "\(user)が\(flow.state)へ差し戻しました。"
    } else if oldState == .writingNumber && action == .next {
      text = "\(user)が申請書No.を記入しました。"
    } else {
      text = "\(user)が\(oldState)を\(flow.state)に変更しました。"
    }
    try await slackClient.chatPostMessage(
      channel: .managementFlows, text: text, options: .init(mrkdwn: true, thread_ts: flow.threadTS)
    )
    
    switch flow.state {
    case .revisioning1, .revisioning2:
      return try await sendRevisionRequest(slackClient, flow: flow).ts
    case .chiefChecking:
      return try await sendCheckRequestToChief(slackClient, flow: flow).ts
    case .exectionUnitChecking:
      return try await sendCheckRequestToExecutionUnit(slackClient, flow: flow).ts
    case .subrepresentativeChecking:
      return try await sendCheckRequestToSubrepresentative(slackClient, flow: flow).ts
    case .writingNumber:
      return try await sendApplicationNumber(req, flow: flow).ts
    case .submitted:
      return try await sendHappy(slackClient, flow: flow).ts
    case .cancelled:
      return try await sendReopenFlow(slackClient, flow: flow).ts
    }
  }
  async let updating: Void = updateMainMessage(flow: flow, slackClient: slackClient)
  async let deleting: Void = deletePreviousActionsMessage(flow: flow, slackClient: slackClient)
  
  flow.recentThreadMessageTS = try await sendingThreadMessages.value
  try await flow.save(on: req.db)
  try await updating
  try await deleting
  req.logger.log(level: .debug, "\(flow)")
}

fileprivate func updateMainMessage(flow: ApplicationFlow, slackClient: SlackClient) async throws {
  try await slackClient.chatUpdate(
    channel: .managementFlows,
    ts: flow.threadTS,
    options: .init(blocks: makeManagemntChannelMessage(flow).blocks)
  )
}

fileprivate func deletePreviousActionsMessage(flow: ApplicationFlow, slackClient: SlackClient) async throws {
  if let ts = flow.recentThreadMessageTS {
    try await slackClient.chatDelete(channel: .managementFlows, ts: ts)
  }
}

fileprivate func sendRevisionRequest(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let coTxt = flow.coAuthores.map(\.description).joined(separator: " ")
  let mrkdwn =  "\(flow.applicantUserID) \(coTxt)\n<\(flow.url)|\(flow.title)>を修正してください。"
  let res = try await slackClient.chatPostMessage(
    channel: .managementFlows, text: mrkdwn, options: .init(thread_ts: flow.threadTS)
  ) {
    Section(.markdown(mrkdwn))
    Actions {
      Button(text: "修正完了", actionID: "next", style: .primary)
      Button(text: "提出をキャンセル", actionID: "revert", style: .danger)
    }.id("thread-actions")
  }
  return (ts: res.ts, _unused: ())
}

func sendCheckRequestToChief(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let mrkdwn = flow.section.boss.map {
    return "\(flow.section.chief)（Cc：\($0)）\n<\(flow.url)|\(flow.title)>をチェックしてください。"
  } ?? "\(flow.section.chief) <\(flow.url)|\(flow.title)>をチェックしてください。"
  return try await sendCheckRequest(slackClient, flow: flow, markdown: mrkdwn)
}

func sendCheckRequestToExecutionUnit(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let mrkdwn = "\(UserGroupID.teamExecution)\n<\(flow.url)|\(flow.title)>をチェックしてください。"
  let text = "執行部隊は<\(flow.url)|\(flow.title)>をチェックしてください。"
  return try await sendCheckRequest(slackClient, flow: flow, markdown: mrkdwn, text: text)
}

func sendCheckRequestToSubrepresentative(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let mrkdwn = "\(UserID.user2)\n<\(flow.url)|\(flow.title)>をチェックしてください。"
  return try await sendCheckRequest(slackClient, flow: flow, markdown: mrkdwn)
}

fileprivate func sendCheckRequest(
  _ slackClient: SlackClient, flow: ApplicationFlow, markdown: String, text: String? = nil
) async throws -> (ts: String, _unused: Void) {
  let res = try await slackClient.chatPostMessage(
    channel: .managementFlows, text: text ?? markdown, options: .init(thread_ts: flow.threadTS)
  ) {
    Section(.markdown(markdown))
    Actions {
      Button(text: "チェック完了", actionID: "next", style: .primary)
      Button(text: "差し戻し", actionID: "revert")
    }.id("thread-actions")
  }
  return (ts: res.ts, _unused: ())
}

func sendApplicationNumber(
  _ req: Request, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  if flow.number == nil {
    let existingMax = try await req.db.query(ApplicationFlow.self).max(\.$number) ?? 0
    flow.number = existingMax + 1
    try await flow.save(on: req.db)
  }
  let number = flow.number!
  let mrkdwn = "\(UserID.user2)\n申請書No.は `\(number)` です。\n記入してSLに提出してください。"
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  let res = try await slackClient.chatPostMessage(
    channel: .managementFlows, text: mrkdwn, options: .init(mrkdwn: true, thread_ts: flow.threadTS)
  ) {
    Section(.markdown(mrkdwn))
    Actions {
      Button(text: "提出完了", actionID: "next", style: .primary)
      Button(text: "No.変更", actionID: "change-number")
      Button(text: "差し戻し", actionID: "revert")
    }.id("thread-actions")
  }
  return (ts: res.ts, _unused: ())
}

func openChangeNumberModal(_ req: Request, ts: String, triggerID: String) async throws {
  let flow = try await getFlow(req, ts: ts)
  var modal = Modal(
    "change-number-modal",
    title: "申請書No.変更",
    submit: "変更",
    close: "キャンセル"
  ) {
    Section(.plainText("\(flow.title)の申請書No.を変更"))
    Input("新しい申請書ナンバー", optional: true) {
      PlainTextInput(actionID: "number-inp")
    }.id("number-sec")
  }
  modal.privateMetadata = ts
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  try await slackClient.viewsOpen(triggerID: triggerID, view: modal)
}

func onNumberChanged(
  _ req: Request, viewSubmission: InteractionPayload.ViewSubmission
) async throws -> Response {
  let ts = viewSubmission.view.private_metadata
  let user = viewSubmission.user.id
  let flow = try await getFlow(req, ts: ts)
  let oldNumber = flow.number
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  guard let numberValue = viewSubmission.view.state.values["number-sec"]?["number-inp"],
        case .plainTextInput(.some(let numberStr)) = numberValue else {
    throw Abort(.internalServerError)
  }
  guard let number = Int(numberStr) else {
    let responseAction = SlackResponseAction.errors(["number_sec": "半角数字で入力してください。"])
    return try Response.json(responseAction, status: .ok)
  }
  flow.number = number
  
  let sendingThreadMessages = Task {
    try await slackClient.chatPostMessage(
      channel: .managementFlows,
      text: (oldNumber != nil)
        ? "\(user)が申請書No.を\(oldNumber!)から\(number)に変更しました。"
        : "\(user)が申請書No.を\(number)に変更しました。",
      options: .init(mrkdwn: true, thread_ts: flow.threadTS)
    )
    let res = try await slackClient.chatPostMessage(
      channel: .managementFlows,
      text: "\(UserID.user2)\n申請書を提出してください。",
      options: .init(mrkdwn: true, thread_ts: flow.threadTS)
    ) {
      Section(.markdown("\(UserID.user2)\n申請書を提出してください。"))
      Actions {
        Button(text: "提出完了", actionID: "next", style: .primary)
        Button(text: "差し戻し", actionID: "revert")
      }.id("thread-actions")
    }
    return res.ts
  }
  async let updating: Void = updateMainMessage(flow: flow, slackClient: slackClient)
  async let deleting: Void = deletePreviousActionsMessage(flow: flow, slackClient: slackClient)
  
  try await updating
  try await deleting
  flow.recentThreadMessageTS = try await sendingThreadMessages.value
  try await flow.save(on: req.db)
  return Response(status: .ok)
}

fileprivate func sendHappy(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let mrkdwn = "<\(flow.url)|\(flow.title)>をSLに提出しました！"
  let res = try await slackClient.chatPostMessage(
    channel: .managementFlows, text: mrkdwn, options: .init(thread_ts: flow.threadTS)
  ) {
    Section(.markdown(mrkdwn), accessory: OverflowMenu(actionID: "revert") {
      Option("フローに戻す", value: "revert")
    }
    ).id("thread-actions")
  }
  return (ts: res.ts, _unused: ())
}

fileprivate func sendReopenFlow(
  _ slackClient: SlackClient, flow: ApplicationFlow
) async throws -> (ts: String, _unused: Void) {
  let text = "<\(flow.url)|\(flow.title)>を再度提出しますか。"
  let res = try await slackClient.chatPostMessage(
    channel: .managementFlows, text: text, options: .init(thread_ts: flow.threadTS)
  ) {
    Section(.markdown(text))
    Actions {
      Button(text: "再提出", actionID: "next")
    }.id("thread-actions")
  }
  return (ts: res.ts, _unused: ())
}
