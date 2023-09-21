import BlockKitBuilder
import Fluent
import SlackClient
import Vapor

func updateHomeTab(_ req: Request, for user: TanaUser) async throws {
  let homeView = try await makeHomeTab(req, for: user)
  let slackClient = SlackClient(req.client, slackBotToken: Environment.SLACK_BOT_TOKEN)
  try await slackClient.viewsPublish(userID: user.id!, view: homeView)
}

func makeHomeTab(_ req: Request, for user: TanaUser) async throws -> HomeTab {
  let sects = user.homeTabState.sections
  let allFlows = try await req.db.query(ApplicationFlow.self).all()
    .filter { user.homeTabState.showAllSections || sects.contains($0.sectionName) }
    .sorted(by: { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) })
  
  return HomeTab(callback_id: "home-tab") {
    Actions {
      StaticSelectMenu(actionID: "category") {
        categoryOption(.yourChecking)
        categoryOption(.appliciated)
        categoryOption(.someoneChecking)
        categoryOption(.all)
      }
      .modify(\.initialOption, with: categoryOption(user.homeTabState.category))
      
      let initialOption = user.homeTabState.showAllSections
        ? Option("全ての局を表示", value: "all")
        : Option("選択した局を表示", value: "selected")
      StaticSelectMenu(actionID: "show-sections-config", initialOption: initialOption) {
        Option("全ての局を表示", value: "all")
        Option("選択した局を表示", value: "selected")
      }
      if !user.homeTabState.showAllSections {
        let placeholderText = user.homeTabState.sections.isEmpty
          ? "表示する局を選択"
          : user.homeTabState.sections.map(\.displayName).joined(separator: ", ")
        StaticSelectMenu(actionID: "sections") {
          for section in TanaSectionName.allCases {
            if user.homeTabState.sections.contains(section) {
              Option("✔︎\t\(section.displayName)", value: section.rawValue)
            } else {
              Option(" \t\(section.displayName)", value: section.rawValue)
            }
          }
        }.placeholder(PlainText(placeholderText))
      }
    }.id("home-tab-state")
    
    Divider()
    
    let flows: [ApplicationFlow] = {
      switch user.homeTabState.category {
      case .yourChecking:
        return allFlows.filter { $0.checkingUserIDs.contains(user.id!) }
      case .appliciated:
        return allFlows.filter { $0.applicantUserID == user.id } + allFlows.filter { $0.coAuthores.contains(user.id!) }
      case .someoneChecking:
        return allFlows.filter { flow in
          [.chiefChecking, .exectionUnitChecking, .subrepresentativeChecking].contains(flow.state)
        }
      case .all:
        return allFlows
      }
    }()
    
    if flows.isEmpty {
      Section(.plainText("条件に当てはまる申請書はありません。"))
    } else if flows.count <= 10 {
      for flow in flows {
        flowView(of: flow)
        Divider()
      }
    } else {
      let currentPage = user.homeTabState.page
      let chunks = flows.chunks(ofCount: 10)
      let _index = chunks.index(chunks.startIndex, offsetBy: currentPage)
      let index = chunks.indices.contains(_index) ? _index : chunks.endIndex
      for flow in chunks[index] {
        flowView(of: flow)
        Divider()
      }
      Actions {
        let lastPage = flows.count / 10
        if currentPage != 0 {
          Button(text: "前へ", actionID: "back")
        }
        StaticSelectMenu(
          actionID: "setto", initialOption: Option("\(currentPage+1)", value: currentPage.description)
        ) {
          for i in 0...lastPage {
            Option("\(i+1)", value: i.description)
          }
        }.placeholder("移動するページを選択")
        if currentPage != lastPage {
          Button(text: "次へ", actionID: "next")
        }
      }.id("home-pagenation")
    }
  }
}

@BlocksBuilder
fileprivate func flowView(of flow: ApplicationFlow) -> [AnyBlock] {
  /* https://2023tanabata.slack.com/archives/
   D04PFM8MFTR
   /p1684117406200559?thread_ts=1684117397.905079&cid=D04PFM8MFTR
   
   https://2023tanabata.slack.com/archives/D04PFM8MFTR/p1684117397905079
   https://2023tanabata.slack.com/archives/C04ESS3JNK1/p1686554142520489
   */
  
  let channelID = ChannelID.managementFlows.rawValue
  let msgTS = flow.recentThreadMessageTS ?? ""
  let threadTS = flow.threadTS ?? ""
  let base = "https://2023tanabata.slack.com/archives"
  let urlStr = "\(base)/\(channelID)/\(msgTS)?thread_ts=\(threadTS)&cid=\(channelID)"
  let url = URL(string: urlStr)
  
  Section(.markdown("*<\(flow.url)|\(flow.title)>*"), accessory:
    Button(text: "View Thread", actionID: "view-thread", url: url)
  )
  Section{
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
    if let createdDate = flow.createdAt {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.locale = .init(identifier: "ja_jp")
      Markdown("*提出日*\n\(formatter.string(from: createdDate))")
    }
  }
  Section(.markdown("*ステータス*\n\(statusString(of: flow))"))
}

fileprivate func categoryOption(_ category: HomeTabState.Category) -> BlockKitBuilder.Option {
  switch category {
  case .yourChecking:    return Option("あなたがチェック中の申請書", value: category.rawValue)
  case .appliciated:     return Option("あなたが提出した申請書", value: category.rawValue)
  case .someoneChecking: return Option("チェック中の全ての申請書", value: category.rawValue)
  case .all:             return Option("全ての申請書", value: category.rawValue)
  }
}
