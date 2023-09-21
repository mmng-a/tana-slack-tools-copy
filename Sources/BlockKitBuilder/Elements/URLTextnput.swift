import struct Foundation.URL

public struct URLTextInput: Element {
  
  fileprivate(set) public var type: String = "url_text_input"
  
  public var actionID: String
  public var initialValue: URL?
  
  public init(actionID: String, initialValue: URL? = nil) {
    self.actionID = actionID
    self.initialValue = initialValue
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case actionID = "action_id"
    case initialValue = "initial_value"
  }
}

extension URLTextInput: Dispatchable {}
extension URLTextInput: FocusableOnLoad {}
extension URLTextInput: PlaceholderShowable {}
