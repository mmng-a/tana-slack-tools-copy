import Vapor
import AnyCodable

@dynamicMemberLookup
public struct Payload<Base: Codable>: Content {
  var base: Base
  var options: [String: any Codable]
  
  public init(_ base: Base, options: [String : (any Codable)?] = [:]) {
    self.base = base
    self.options = options.compactMapValues { $0 }
  }
  
  @_disfavoredOverload
  public init(_ base: Base, options: [String: (any Codable)] = [:]) {
    self.base = base
    self.options = options
  }
  
  public subscript<T>(dynamicMember keyPath: KeyPath<Base, T>) -> T {
    base[keyPath: keyPath]
  }
  
  @_disfavoredOverload
  public subscript(dynamicMember key: String) -> Any? {
    if let option = options[key] {
      return AnyCodable(option).value
    } else {
      return nil
    }
  }
}

extension Payload {
  public func encode(to encoder: Encoder) throws {
    try base.encode(to: encoder)
    var container = encoder.container(keyedBy: BasicCodingKey.self)
    for (key, value) in options {
      try container.encode(value, forKey: .key(key))
    }
  }
  
  public init(from decoder: Decoder) throws {
    self.base = try Base(from: decoder)
    self.options = try [String: AnyCodable].init(from: decoder)
  }
}

public struct EmptyCodable: Codable {}

extension Payload where Base == EmptyCodable {
  @_disfavoredOverload
  public init(_ options: [String: (any Codable)]) {
    self.init(EmptyCodable(), options: options)
  }
  
  public init(_ options: [String: (any Codable)?]) {
    self.init(EmptyCodable(), options: options)
  }
}
