public struct Message: Codable {
  public var blocks: [AnyBlock]
  
  public init(@BlocksBuilder _ blocks: () -> [AnyBlock]) {
    self.blocks = blocks()
  }
}
