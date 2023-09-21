public protocol Element: Codable, Modifiable {
  var type: String { get }
}

public enum ElementTypeCodingKey: CodingKey {
  case type
}
