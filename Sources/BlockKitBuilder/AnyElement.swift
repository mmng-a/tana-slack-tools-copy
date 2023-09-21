public struct AnyElement: Element {
  
  public var type: String { value.type }
  private(set) var value: any Element
  
  public func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ElementTypeCodingKey.self)
    let type = try container.decode(String.self, forKey: .type)
    let elementTypes: [String: Element.Type] = [
      "plain_text":          PlainText.self,
      "mrkdwn":              Markdown.self,
      "button":              Button.self,
      "checkboxes":          CheckBoxes.self,
      "multi_static_select": MultiStaticSelectMenu.self,
      "multi_users_select":  MultiUsersSelectMenu.self,
      "overflow":            OverflowMenu.self,
      "plain_text_input":    PlainTextInput.self,
      "static_select":       StaticSelectMenu.self,
      "url_text_input":      URLTextInput.self,
    ]
    guard let elementType = elementTypes[type] else {
      throw DecodingError.dataCorruptedError(forKey: ElementTypeCodingKey.type, in: container, debugDescription: "unknown type '\(type)'")
    }
    
    self.value = try elementType.init(from: decoder)
  }
  
  public init(_ value: any Element) {
    self.value = value
  }
}
