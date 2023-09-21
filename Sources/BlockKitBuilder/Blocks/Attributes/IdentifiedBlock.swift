public struct IDentifiedBlock<BaseBlock: Block>: Block {
  public var type: String { base.type }
  var id: String
  var base: BaseBlock
  
  enum IDCodingKey: String, CodingKey {
    case id = "block_id"
  }
  
  public func encode(to encoder: Encoder) throws {
    var baseContainer = encoder.singleValueContainer()
    try baseContainer.encode(base)
    var idContainer = encoder.container(keyedBy: IDCodingKey.self)
    try idContainer.encode(id, forKey: .id)
  }
}

extension Block {
  public func id(_ id: String) -> IDentifiedBlock<Self> {
    IDentifiedBlock(id: id, base: self)
  }
}

extension IDentifiedBlock {
  public func id(_ id: String) -> IDentifiedBlock<BaseBlock> {
    IDentifiedBlock(id: id, base: self.base)
  }
}
