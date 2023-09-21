import BlockKitBuilder
import SlackClient
import Vapor

func submittedNewAppModal(
  _ req: Request,
  submittionPayload payload: InteractionPayload.ViewSubmission
) async throws -> Response {
  guard let titleValue = payload.view.state.values["name_sec"]?["name_inp"],
        case .plainTextInput(.some(let title)) = titleValue,
        let urlValue = payload.view.state.values["url_sec"]?["url_inp"],
        case .urlTextInput(.some(var uri)) = urlValue,
        let sectionValue = payload.view.state.values["sec_sec"]?["sec_inp"],
        case .staticSelect(.some(let sectionOption)) = sectionValue,
        let tanaSectionName = TanaSectionName(rawValue: sectionOption.value),
        let coAuthsValue = payload.view.state.values["co-auth-sec"]?["co-auth-inp"],
        case .multiUsersSelect(let coAuthores) = coAuthsValue else { throw Abort(.internalServerError) }
  guard uri.scheme == "https",
        uri.host == "drive.google.com" || uri.host == "docs.google.com" else {
    let responseAction = SlackResponseAction.errors(["url_sec": "無効なURLです（Google DocsのURLを入力してください）。"])
    return try Response.json(responseAction, status: .ok)
  }
  
  uri.fragment = nil
  uri.query = nil
  let url = URL(string: uri.string)!
  
  let client = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  
  Task {
    try await client.conversationsInvite(channel: .managementFlows, users: [payload.user.id])
  }
  
  let user = try await TanaUser.find(payload.user.id, on: req.db) ?? TanaUser(id: payload.user.id)
  let newFlow = ApplicationFlow(
    title: title,
    url: url,
    state: .chiefChecking,
    threadTS: nil,
    applicantUserID: user.id!,
    coAuthores: coAuthores,
    sectionName: tanaSectionName
  )
  
  if let numberValue = payload.view.state.values["number-sec"]?["number-inp"],
     case .plainTextInput(let numOptStr) = numberValue,
     case .some(let numStr) = numOptStr {
    guard let num = Int(numStr) else {
      let responseAction = SlackResponseAction.errors(["number-sec": "数字を入力してください。"])
      return try Response.json(responseAction, status: .ok)
    }
    newFlow.number = num
  }
  
  user.addRecentSection(tanaSectionName)
  try await user.save(on: req.db)
  let view = makeManagemntChannelMessage(newFlow)
  let res = try await client.chatPostMessage(channel: .managementFlows, message: view, text: title)
  newFlow.threadTS = res.ts
  let threadRes = try await sendCheckRequestToChief(client, flow: newFlow)
  newFlow.recentThreadMessageTS = threadRes.ts
  try await newFlow.create(on: req.db)
  return Response(status: .ok)
}
