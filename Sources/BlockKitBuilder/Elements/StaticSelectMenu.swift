public struct StaticSelectMenu: Element {
  
  fileprivate(set) public var type: String = "static_select"
  
  public var actionID: String
  
  public var options: [Option]?
  public var optionGroups: [OptionGroup]?
  
  public var initialOption: Option?
  
  public init(actionID: String, initialOption: Option? = nil, @OptionsBuilder options: () -> [Option]) {
    self.actionID = actionID
    self.initialOption = initialOption
    self.options = options()
    self.optionGroups = nil
  }
  
  public init(actionID: String, initialOption: Option? = nil, @OptionGroupsBuilder optionGroups: () -> [OptionGroup]) {
    self.actionID = actionID
    self.initialOption = initialOption
    self.options = nil
    self.optionGroups = optionGroups()
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case options = "options"
    case optionGroups = "option_groups"
    case initialOption = "initial_option"
  }
}

extension StaticSelectMenu: FocusableOnLoad {}
extension StaticSelectMenu: ConfirmarionShowable {}
extension StaticSelectMenu: PlaceholderShowable {}
