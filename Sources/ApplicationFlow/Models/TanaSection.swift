import SlackClient

struct TanaSection: Equatable, Hashable {
  var name: TanaSectionName
  var chief: UserID
  var boss: UserID?
  
  init(_ name: TanaSectionName, chief: UserID, boss: UserID?) {
    self.name = name
    self.chief = chief
    self.boss = boss
  }
}

extension TanaSection {
  init(_ name: TanaSectionName) {
    switch name {
    case .asignment:        self = TanaSection(name, chief: .user6, boss: .user1)
    case .event:            self = TanaSection(name, chief: .user7, boss: nil)
    case .ornament:         self = TanaSection(name, chief: .user8, boss: .user2)
    case .generalAffairs:   self = TanaSection(name, chief: .user6, boss: .user3)
    case .stage:            self = TanaSection(name, chief: .user7, boss: .user3)
    case .system:           self = TanaSection(name, chief: .user8, boss: .user3)
    case .teamExecution:    self = TanaSection(name, chief: .user6, boss: .user3)
    case .publicRelation:   self = TanaSection(name, chief: .user7, boss: .user4)
    case .customerRelation: self = TanaSection(name, chief: .user8, boss: .user4)
    case .design:           self = TanaSection(name, chief: .user6, boss: .user4)
    case .teamStrategy:     self = TanaSection(name, chief: .user7, boss: nil)
    case .account:          self = TanaSection(name, chief: .user8, boss: nil)
      
    case .pj_pamphlet:      self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_map:           self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_biztrip:       self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_webAd:         self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_intern:        self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_academic:      self = TanaSection(name, chief: .user4, boss: nil)
    case .pj_yukata:        self = TanaSection(name, chief: .user4, boss: nil)
      
    case .other:            self = TanaSection(name, chief: .user3, boss: nil)
    }
  }
}

enum TanaSectionName: String, Hashable, Codable, CaseIterable {
  
  case asignment
  case event
  case ornament
  case generalAffairs
  case stage
  case system
  case teamExecution
  case publicRelation
  case customerRelation
  case design
  case teamStrategy
  case account
  
  case pj_pamphlet
  case pj_map
  case pj_biztrip
  case pj_webAd
  case pj_intern
  case pj_academic
  case pj_yukata
  
  case other
  
  var displayName: String {
    switch self {
    case .asignment:        return "配属局"
    case .event:            return "企画局"
      
    case .ornament:         return "装飾局"
    case .generalAffairs:   return "総務局"
    case .stage:            return "ステージ局"
    case .system:           return "システム局"
    case .teamExecution:    return "執行部隊"
    case .publicRelation:   return "広報局"
    case .customerRelation: return "渉外局"
    case .design:           return "デザイン局"
    case .teamStrategy:     return "戦略部隊"
    case .account:          return "会計部"
      
    case .pj_pamphlet:      return "PJ パンフレット"
    case .pj_map:           return "PJ マップ"
    case .pj_biztrip:       return "PJ 出張お祭り隊"
    case .pj_webAd:         return "PJ ウェブ広告"
    case .pj_intern:        return "PJ インターン"
    case .pj_academic:      return "PJ 学術"
    case .pj_yukata:        return "PJ 浴衣"
      
    case .other:            return "その他"
    }
  }
}

extension TanaSectionName {
  static let allSections: [TanaSectionName] = [
    .asignment, .event, .ornament,
    .generalAffairs, .stage, .system, .teamExecution,
    .publicRelation, .design, .customerRelation, .teamStrategy,
    .account,
  ]
  
  static let allProjects: [TanaSectionName] = [
    .pj_academic, .pj_biztrip, .pj_intern, .pj_map, .pj_pamphlet, .pj_webAd, .pj_yukata
  ]
}
