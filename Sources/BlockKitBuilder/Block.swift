public protocol Block: Codable, Modifiable {
  var type: String { get }
}

public enum BlockTypeCodingKey: CodingKey {
  case type
}
