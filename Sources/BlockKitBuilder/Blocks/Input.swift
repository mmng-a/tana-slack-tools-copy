public struct Input<Element: InputElementable>: Block {
  
  fileprivate(set) public var type: String = "input"
  
  var label: PlainText
  var element: Element
  
  var dispatchAction: Bool?
  var hint: PlainText?
  var optional: Bool?
  
  public init(
    _ label: PlainText,
    hint: PlainText? = nil,
    dispatchAction: Bool? = nil,
    optional: Bool? = nil,
    element: () -> Element
  ) {
    self.label = label
    self.element = element()
    self.dispatchAction = dispatchAction
    self.hint = hint
    self.optional = optional
  }
}

