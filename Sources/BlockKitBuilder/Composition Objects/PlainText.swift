public struct PlainText: Element {
  
  fileprivate(set) public var type: String = "plain_text"
  
  public var text: String
  public var emoji: Bool?
  
  public init(_ text: String, emoji: Bool? = nil) {
    self.text = text
    self.emoji = emoji
  }
}

extension PlainText: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self.text = value
    self.emoji = nil
  }
}
