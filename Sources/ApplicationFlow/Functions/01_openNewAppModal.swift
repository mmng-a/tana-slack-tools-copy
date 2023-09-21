import BlockKitBuilder
import SlackClient
import Vapor

func configureOpenNewAppModal(_ slackApp: SlackApp) {
  slackApp.onShortcut("new_application") { req, shortcut in
    try await openNewAppModal(req, triggerID: shortcut.triggerID, userID: shortcut.user.id)
  }
  slackApp.onViewSubmission("new-app-modal") { req, viewSubmission in
    return try await submittedNewAppModal(req, submittionPayload: viewSubmission)
  }
  
  slackApp.onBlockAction(blockID: "sec-sec", actionID: "sec-inp") { _, _ in }
}

func openNewAppModal(_ req: Request, triggerID: String, userID: UserID) async throws {
  let client = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  let user = try await TanaUser.find(userID, on: req.db)
  
  let view = Modal("new-app-modal", title: "新規申請書", submit: "提出", close: "キャンセル") {
    Input("申請書名") {
      PlainTextInput(actionID: "name_inp")
        .placeholder("例：第34回七夕際開催申請書")
        .focusOnLoad()
    }.id("name_sec")
    Input("申請書URL", hint: "申請書は必ず必ずドライブに移動してください") {
      URLTextInput(actionID: "url_inp")
        .placeholder("例：https://docs.google.com/document/d/xxx")
    }.id("url_sec")
    Input("所属局") {
      StaticSelectMenu(actionID: "sec_inp") {
        if let user, !user.recentSections.isEmpty {
          OptionGroup("履歴", data: user.recentSections) { section in
            Option(section.displayName, value: section.rawValue)
          }
        }
        OptionGroup("局", data: TanaSectionName.allSections) { section in
          Option(section.displayName, value: section.rawValue)
        }
        OptionGroup("プロジェクト", data: TanaSectionName.allProjects) { pj in
          Option(pj.displayName, value: pj.rawValue)
        }
        OptionGroup("その他") {
          Option("その他", value: TanaSectionName.other.rawValue)
        }
      }.placeholder("例：総務局")
    }.id("sec_sec")
    Input("共同作成者", optional: true) {
      MultiUsersSelectMenu(actionID: "co-auth-inp")
    }.id("co-auth-sec")
    Input("申請書ナンバー", hint: "修正などの際はこちらに申請書No.を入力してください。", optional: true) {
      PlainTextInput(actionID: "number-inp")
    }.id("number-sec")
  }
  
  try await client.viewsOpen(triggerID: triggerID, view: view)
}
