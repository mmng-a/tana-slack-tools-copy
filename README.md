# Tana Slack Tools Copy for Hagino-ken

個人情報が大量に含まれているライブラリであったため、一部変更しています。

- 使用言語：Swift 5.7
- 主要フレームワーク：[Vapor](https://vapor.codes)

以下は各targetの簡単な説明

## Slackアプリ

### Application Flow

申請書承認フローを管理します。

## ライブラリ

このパッケージには以下3つのライブラリが含まれています。
別パッケージとして公開したいのですが、SlackClientに未実装部分が多く、公開するに至っておりません。

### SlackClient

SlackのWeb APIを呼び出す、Event APIに反応するなどができます。

例：

```swift
import SlackClient
import Vapor

// Vaporでルートをする標準パターン`func routes(_:)`
func routes(_ routesBuilder: some RoutesBuilder) throws {
  let slackApp = SlackApp(routesBuilder)
  // `get-my-channel-list`というIDのショートカットが起動された時に実行される処理
  slackApp.slackApp.onShortcut("get-my-channel-list") { req, shortcut in
    try await responseGetMyChannelList(req, triggerID: shortcut.triggerID, userID: shortcut.user.id)
  }
}

func responseGetMyChannelList(_ req: Request, triggerID: TriggerID, userID: UserID) async throws {
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  do {
    let channels = try await slackClient.usersConversations(userID: userID)
      .channels
      .sorted(by: \.name)
      .map { $0.channel }
    let blocks = Message {
      Section(.plainText("あなたのチャンネル一覧です"))
      Divider()
      Section {
        for channel in channels {
          Text.markdown(channel.description)
        }
      }
    }
    try await slackClient.postEphemeralMessage(triggerID: triggerID, blocks: blocks)
  } catch {
    let errorMessage = "あなたのチャンネルリストを取得できませんでした。"
    try await slackClient.postEphemeralMessage(triggerID: triggerID, text: errorMessage)
  }
}
}
```

### BlockKitBuilder

Slackの[BlockKit](https://api.slack.com/block-kit)を構築するためのライブラリです。
@resultBuilderを使用しており、SwiftUIのように宣言的UIで記述できます。

例

```swift 
Message {
  Section(.plainText("出席フォームを入力してください"), accessory:
    Button(
      text: "出席フォームを開く :wake_up",
      actionID: "button-action",
      url: URL(string: "https://forms.gle/xxxxxxxx")
    )
  )
}
```

### SlackPrimaryTypes

上記2つどちらでも使用する基本的な型について定義しています。
