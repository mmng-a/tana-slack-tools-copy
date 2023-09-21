public struct FileBlock: Block {
  
  fileprivate(set) public var type: String = "file"
  
  var externalID: String
  var source = "remote"
  
  enum CodingKeys: String, CodingKey {
    case type
    case externalID = "external_id"
    case source
  }
}
