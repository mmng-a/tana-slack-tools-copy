import Fluent
import SlackClient
import Vapor

// データベースを一度飛ばしてしまったので、その復帰用
func configureExtAppRegister(_ app: SlackApp) {
  app.onShortcut("regist-ext-app") { req, shortcut in
    try await openExtAppRegister(req, triggerID: shortcut.triggerID)
  }
  app.onViewSubmission("ext-app-register") { req, viewSubmission in
    try await submittedExtAppRegister(req, submittedPayload: viewSubmission)
  }
}

func openExtAppRegister(_ req: Request, triggerID: String) async throws {
  let client = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  
  let view = Modal("ext-app-register", title: "migration失敗した、、", submit: "登録", close: "キャンセル") {
    Input("old message") {
      PlainTextInput(actionID: "ext-msg")
    }.id("ext-msg")
    Input("名前") {
      PlainTextInput(actionID: "name")
    }.id("name")
    Input("url") {
      PlainTextInput(actionID: "url")
    }.id("url")
    Input("局") {
      StaticSelectMenu(actionID: "sec") {
        OptionGroup("局", data: TanaSectionName.allSections) { section in
          Option(section.displayName, value: section.rawValue)
        }
        OptionGroup("プロジェクト", data: TanaSectionName.allProjects) { pj in
          Option(pj.displayName, value: pj.rawValue)
        }
        OptionGroup("その他") {
          Option("その他", value: TanaSectionName.other.rawValue)
        }
      }
    }.id("sec")
    Input("提出者") {
      MultiUsersSelectMenu(actionID: "users")
    }.id("users")
    Input("ステータス") {
      StaticSelectMenu(actionID: "state") {
        for state in State.allCases {
          Option(state.description, value: state.rawValue.description)
        }
      }
    }.id("state")
  }
  try await client.viewsOpen(triggerID: triggerID, view: view)
}

func submittedExtAppRegister(
  _ req: Request,
  submittedPayload payload: InteractionPayload.ViewSubmission
) async throws {
  let pattern = #/https://2023tanabata\.slack\.com/archives/\w+/p(?<msgA>\d{10})(?<msgB>\d{6})\?thread_ts=(?<thrA>\d{10})\.(?<thrB>\d{6})&cid=\w+/#
  guard let extMsgValue = payload.view.state.values["ext-msg"]?["ext-msg"],
        case .plainTextInput(.some(let extMsg)) = extMsgValue,
        let (msgTS, threadTS) = try pattern.firstMatch(in: extMsg)
          .map({ match in
            return ("\(match.output.msgA).\(match.output.msgB)",
                    "\(match.output.thrA).\(match.output.thrB)")
          }),
        let nameValue = payload.view.state.values["name"]?["name"],
        case .plainTextInput(.some(let name)) = nameValue,
        let urlValue = payload.view.state.values["url"]?["url"],
        case .plainTextInput(.some(let _url)) = urlValue,
        let url = URL(string: _url),
        let secValue = payload.view.state.values["sec"]?["sec"],
        case .staticSelect(.some(let _sec)) = secValue,
        let sec = TanaSectionName(rawValue: _sec.value),
        let usersValue = payload.view.state.values["users"]?["users"],
        case .multiUsersSelect(let users) = usersValue,
        let author = users.first,
        let stateValue = payload.view.state.values["state"]?["state"],
        case .staticSelect(.some(let _state)) = stateValue,
        let stateRaw = Int(_state.value),
        let state = State(rawValue: stateRaw) else {
    throw Abort(.badRequest)
  }
  let newFlow = ApplicationFlow(
    title: name,
    url: url,
    state: state,
    threadTS: threadTS,
    applicantUserID: author,
    coAuthores: users.count == 1 ? [] : Array(users[1...]),
    sectionName: sec
  )
  newFlow.recentThreadMessageTS = msgTS
  try await newFlow.create(on: req.db)
  
  let client = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  try await client.chatPostMessage(channel: "D04KY92NZ2P", text: "sucess registering \(name)")
  
  throw Abort(.internalServerError)
}
