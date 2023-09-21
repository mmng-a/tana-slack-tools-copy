public struct MultiStaticSelectMenu: Element {
  fileprivate(set) public var type: String = "multi_static_select"
  public var actionID: String
  public var options: [Option]?
  public var optionGroups: [OptionGroup]?
  public var initialOptions: [Option]
  public var maxSelectedItems: Int
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case options
    case optionGroups = "option_groups"
    case initialOptions = "initial_options"
    case maxSelectedItems = "max_selected_items"
  }
  
  public init(actionID: String, options: [Option]? = nil, optionGroups: [OptionGroup]? = nil, initialOptions: [Option], maxSelectedItems: Int) {
    self.actionID = actionID
    self.options = options
    self.optionGroups = optionGroups
    self.initialOptions = initialOptions
    self.maxSelectedItems = maxSelectedItems
  }
}

extension MultiStaticSelectMenu: ConfirmarionShowable {}
extension MultiStaticSelectMenu: FocusableOnLoad {}
extension MultiStaticSelectMenu: PlaceholderShowable {}
