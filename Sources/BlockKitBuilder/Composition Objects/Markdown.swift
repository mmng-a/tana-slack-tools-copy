public struct Markdown: Element {
  
  fileprivate(set) public var type: String = "mrkdwn"
  public var text: String
  public var verbatim: Bool?
  
  public init(_ text: String, verbatim: Bool? = nil) {
    self.text = text
    self.verbatim = verbatim
  }
}

extension Markdown: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.text = value
    self.verbatim = nil
  }
}
