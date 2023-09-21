import BlockKitBuilder
import SlackClient
import Vapor

func statusString(of flow: ApplicationFlow) -> String {
  switch flow.state {
  case .cancelled:
    return "キャンセル済み"
  case .revisioning1:
    if flow.coAuthores.isEmpty {
      return "局長🚫 → 修正中（\(flow.applicantUserID)）"
    } else {
      let txt = flow.coAuthores.map(\.description).joined(separator: " ")
      return "局長🚫 → 修正中（\(flow.applicantUserID) \(txt)）"
    }
  case .chiefChecking:
    if let boss = flow.section.boss {
      return "局長・部長チェック（\(flow.section.chief) Cc: \(boss)）"
    } else {
      return "局長・部長チェック（\(flow.section.chief) ）"
    }
  case .revisioning2:
    if flow.coAuthores.isEmpty {
      return "局長✅ → 執行部隊🚫 → 修正中（\(flow.applicantUserID)）"
    } else {
      let txt = flow.coAuthores.map(\.rawValue).joined(separator: " ")
      return "局長✅ → 執行部隊🚫 → 修正中（\(flow.applicantUserID) \(txt)）"
    }
  case .exectionUnitChecking:
    return "局長✅ → 執行部隊チェック（\(UserGroupID.teamExecution)）"
  case .subrepresentativeChecking:
    return "局長✅ → 執行部隊✅ → 副代表チェック（\(UserID.user2)）"
  case .writingNumber:
    return "局長✅ → 執行部隊✅ → 副代表チェック✅ → 申請書ナンバー記入（\(UserID.user2)）"
  case .submitted:
    return "提出済"
  }
}

func makeManagemntChannelMessage(_ flow: ApplicationFlow) -> Message {
  Message {
    Section(.markdown("*<\(flow.url)|\(flow.title)>*"))
    Section {
      if flow.coAuthores.isEmpty {
        Markdown("*提出者*\n\(flow.applicantUserID)")
      } else {
        let txt = flow.coAuthores.map(\.description).joined(separator: ", ")
        Markdown("*提出者*\n\(flow.applicantUserID)（\(txt)）")
      }
      
      Markdown("*所属*\n\(flow.sectionName.displayName)")
      if let number = flow.number {
        Markdown("*申請書ナンバー*\nNo. \(number)")
      }
    }
    Section(.markdown("*ステータス*\n\(statusString(of: flow))"))
    
    switch flow.state {
    case .chiefChecking, .exectionUnitChecking, .subrepresentativeChecking:
      Actions {
        Button(text: "チェック完了", actionID: "next", style: .primary)
      }.id("view-actions")
    case .revisioning1, .revisioning2:
      Actions {
        Button(text: "修正完了", actionID: "next", style: .primary)
      }.id("view-actions")
    case .writingNumber:
      Actions {
        Button(text: "記入完了", actionID: "next", style: .primary)
      }.id("view-actions")
    case .submitted, .cancelled:
      let _: Void = ()
    }
  }
}
