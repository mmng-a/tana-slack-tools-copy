public struct AttributedElement<BaseElement: Element>: Element {
  
  public var type: String { base.type }
  
  public var base: BaseElement
  var _attributes: [String: any Codable]
  
  public init(base: BaseElement) {
    self.base = base
    self._attributes = [:]
  }
  
  struct StringCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    static func key(_ value: String) -> StringCodingKey {
      return StringCodingKey(stringValue: value)
    }
    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { fatalError() }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)
    for (key, attribute) in _attributes {
      try container.encode(attribute, forKey: .key(key))
    }
    try base.encode(to: encoder)
  }
  
  public init(from decoder: Decoder) throws {
    self._attributes = [:]
    let container = try decoder.container(keyedBy: StringCodingKey.self)
    let supportedAttributes: [String: Codable.Type] = [
      "dispatch_action_config" : DispatchActionConfig.self,
      "focus_on_load" : Bool.self,
      "placeholder" : PlainText.self,
      "confirm" : Confirmation.self
    ]
    for (key, valueType) in supportedAttributes {
      let value = try container.decodeIfPresent(valueType, forKey: .key(key))
      _attributes[key] = value
    }
    base = try BaseElement(from: decoder)
  }
}

