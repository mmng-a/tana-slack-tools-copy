public struct OverflowMenu: Element {
  
  fileprivate(set) public var type: String = "overflow"
  
  public var actionID: String
  public var options: [Option]
  
  public init(actionID: String, @OptionsBuilder _ options: () -> [Option]) {
    self.actionID = actionID
    self.options = options()
  }
  
  public init(options: [Option], actionID: String) {
    self.actionID = actionID
    self.options = options
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case options
  }
}

extension OverflowMenu: ConfirmarionShowable {}
