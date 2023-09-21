import Fluent

final class HomeTabState: Fields {
  
  @Field(key: "category")
  var category: Category {
    didSet { page = 0 }
  }
  
  @Field(key: "sections")
  var sections: Set<TanaSectionName> {
    didSet { page = 0 }
  }
  
  @Field(key: "show-all-sections")
  var showAllSections: Bool {
    didSet { page = 0 }
  }
  
  @Field(key: "page")
  var page: Int
  
  init() {
    self.category = .yourChecking
    self.sections = []
    self.showAllSections = true
    self.page = 0
  }
  
  static var `default`: Self {
    Self()
  }
}

extension HomeTabState {
  enum Category: String, Codable {
    case yourChecking, appliciated, someoneChecking, all
  }
}
