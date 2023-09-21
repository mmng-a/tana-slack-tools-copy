import Fluent
import Vapor
import SlackClient

final class TanaUser: Model, Content {
  
  static let schema = "users"
  
  @ID(custom: .id, generatedBy: .user)
  var id: UserID?
  
  @Field(key: "recent-sections")
  var _recentSections: [TanaSectionName]
  
  @Group(key: "home-tab-state")
  var homeTabState: HomeTabState
  
  var recentSections: [TanaSectionName] {
    get { _recentSections }
  }
  
  func addRecentSection(_ new: TanaSectionName) {
    _recentSections.insert(new, at: 0)
    _recentSections = Array(_recentSections.uniqued().prefix(3))
  }
  
  init() {}
  
  init(id: UserID, recentSections: [TanaSectionName] = []) {
    self.id = id
    self._recentSections = Array(recentSections.uniqued().prefix(3))
    self.homeTabState = HomeTabState()
  }
  
  init(id: String, recentSections: [TanaSectionName] = []) {
    self.id = UserID(id)
    self._recentSections = Array(recentSections.uniqued().prefix(3))
    self.homeTabState = HomeTabState()
  }
}

extension UserID {
  // exectives
  static let user1 = UserID("U044XXXXXXX")
  static let user2 = UserID("U044XXXXXXX")
  static let user3 = UserID("U044XXXXXXX")
  static let user4 = UserID("U044XXXXXXX")
  static let user5 = UserID("U044XXXXXXX")
  
  // managers
  static let user6 = UserID("U044XXXXXXX")
  static let user7 = UserID("U044XXXXXXX")
  static let user8 = UserID("U044XXXXXXX")
  /* ... */
  
  // team execution
  static let masashi_aso = UserID("U044XXXXXXX")
  static let user9 = UserID("U044XXXXXXX")
  /* ... */
}
