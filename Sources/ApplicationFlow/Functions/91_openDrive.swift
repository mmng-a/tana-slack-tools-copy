import BlockKitBuilder
import Foundation
import Vapor

func openDriveMessage() -> Message {
  Message {
    Section(.plainText("申請書管理ドライブ（SL委員会との共有ドライブ）"), accessory:
      Button(
        text: "Open Drive :drive:",
        actionID: "button-action",
        url: URL(string: "https://drive.google.com/drive/u/0/folders/xxxxxxxx")
      )
    )
  }
}
