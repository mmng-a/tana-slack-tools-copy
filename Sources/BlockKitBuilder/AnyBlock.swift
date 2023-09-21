public struct AnyBlock: Block {
  
  public var type: String { value.type }
  private(set) var value: any Block
  
  public func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BlockTypeCodingKey.self)
    let type = try container.decode(String.self, forKey: .type)
    let blockTypes: [String: Block.Type] = [
      "actions":  Actions.self,
      "context":  ContextBlock.self,
      "divider":  Divider.self,
      "file":     FileBlock.self,
      "header":   Header.self,
      "image":    ImageBlock.self,
      "input":    Input<AnyElement>.self,
      "section":  Section.self,
      "video":    VideoBlock.self,
    ]
    guard let blockType = blockTypes[type] else {
      throw DecodingError.dataCorruptedError(forKey: BlockTypeCodingKey.type, in: container, debugDescription: "unknown block type '\(type)'")
    }
    
    self.value = try blockType.init(from: decoder)
    
    let idContainer = try decoder.container(keyedBy: IDentifiedBlock<AnyBlock>.IDCodingKey.self)
    if let id = try idContainer.decodeIfPresent(String.self, forKey: .id) {
      self.value = IDentifiedBlock(id: id, base: AnyBlock(self.value))
    }
  }
  
  public init(_ value: any Block) {
    self.value = value
  }
}
