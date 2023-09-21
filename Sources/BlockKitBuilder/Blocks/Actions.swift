public struct Actions: Block {

  fileprivate(set) public var type: String = "actions"

  var elements: [AnyElement]
  
  public init(@ActionsElementsBuilder elements: () -> [any ActionsElementable]) {
    self.elements = elements().map(AnyElement.init)
  }
}
