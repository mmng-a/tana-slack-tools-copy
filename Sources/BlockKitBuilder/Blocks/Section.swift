public struct Section: Block {
  
  fileprivate(set) public var type: String = "section"
  
  let text: Text?
  var fields: [AnyElement]?
  let accessory: AnyElement?
  
  public init(
    _ text: Text,
    accessory: (any Element)? = nil,
    @ElementsBuilder fields: () -> [AnyElement]
  ) {
    self.text = text
    self.fields = fields()
    self.accessory = accessory.map { AnyElement($0) }
  }
  
  public init(
    _ text: Text,
    accessory: (any Element)? = nil
  ) {
    self.text = text
    self.fields = nil
    self.accessory = accessory.map { AnyElement($0) }
  }
  
  public init(
    accessory: (any Element)? = nil,
    @ElementsBuilder fields: () -> [AnyElement]
  ) {
    self.text = nil
    self.fields = fields()
    self.accessory = accessory.map { AnyElement($0) }
  }
}
