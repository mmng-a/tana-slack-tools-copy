public protocol SlackIDProtocol: Codable, Hashable, RawRepresentable, Equatable, ExpressibleByStringLiteral {
  var rawValue: String { get }
  init(_ id: String)
}

extension SlackIDProtocol {
  
  public init(rawValue: String) { self.init(rawValue) }
  public init(stringLiteral value: String) { self.init(value) }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
  
  public init(from decoder: Decoder) throws {
    let value = try decoder.singleValueContainer().decode(String.self)
    self.init(value)
  }
}
