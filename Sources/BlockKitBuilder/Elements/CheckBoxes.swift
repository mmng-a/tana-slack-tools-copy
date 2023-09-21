public struct CheckBoxes: Element {
  
  fileprivate(set) public var type: String = "checkboxes"
  
  public var actionID: String
  public var options: [Option]
  public var initialOptions: [Option]
  
  public init(
    _ actionID: String,
    @OptionsBuilder options: () -> [Option],
    @OptionsBuilder initialOptions: (() -> [Option]) = { [] }
  ) {
    self.actionID = actionID
    self.options = options()
    self.initialOptions = initialOptions()
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case options
    case initialOptions = "initial_options"
  }
}

extension CheckBoxes: ConfirmarionShowable {}
extension CheckBoxes: FocusableOnLoad {}
