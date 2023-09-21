public struct Header: Block {
  
  fileprivate(set) public var type: String = "header"
  
  var text: PlainText
  
  public init(_ text: PlainText) {
    self.text = text
  }
}
