public struct PlainTextInput: Element {
  
  fileprivate(set) public var type: String = "plain_text_input"
  
  public var actionID: String
  public var initialValue: String?
  public var multiline: Bool?
  public var minLength: Int?
  public var maxLength: Int?
  
  public init(
    actionID: String,
    initialValue: String? = nil,
    multiline: Bool? = nil,
    minLength: Int? = nil,
    maxLength: Int? = nil
  ) {
    self.actionID = actionID
    self.initialValue = initialValue
    self.multiline = multiline
    self.minLength = minLength
    self.maxLength = maxLength
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case initialValue = "initial_value"
    case multiline = "multiline"
    case minLength = "min_length"
    case maxLength = "max_length"
  }
}

extension PlainTextInput: FocusableOnLoad {}
extension PlainTextInput: PlaceholderShowable {}
extension PlainTextInput: Dispatchable {}
