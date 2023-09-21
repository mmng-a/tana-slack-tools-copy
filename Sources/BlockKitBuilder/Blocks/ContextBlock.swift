public struct ContextBlock: Block {
  
  fileprivate(set) public var type: String = "context"

  var elements: [AnyElement]
  
  public init(
    @ContextBlockElementsBuilder elements: () -> [any ContextBlockElementable]
  ) {
    self.elements = elements().map(AnyElement.init)
  }
}
