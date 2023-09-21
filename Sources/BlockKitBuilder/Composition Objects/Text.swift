public enum Text: Element {
  
  public var type: String {
    switch self {
    case .plainText(_): return "plain_text"
    case .markdown(_): return "mrkdwn"
    }
  }
  
  case plainText(PlainText)
  case markdown(Markdown)
  
  enum TypeCodingKeys: CodingKey {
    case type
  }
  
  public init(from decoder: Decoder) throws {
    let typeContainer = try decoder.container(keyedBy: TypeCodingKeys.self)
    let type = try typeContainer.decode(String.self, forKey: .type)
    switch type {
    case "plain_text":
      self = .plainText(try PlainText(from: decoder))
    case "mrkdwn":
      self = .markdown(try Markdown(from: decoder))
    default:
      throw DecodingError.dataCorruptedError(
        forKey: TypeCodingKeys.type, in: typeContainer,
        debugDescription: "'\(type)' is unknown type")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .plainText(let plainText): try container.encode(plainText)
    case .markdown(let markdown):   try container.encode(markdown)
    }
  }
  
  public static func plainText(_ text: String, emoji: Bool? = nil) -> Self {
    .plainText(PlainText(text, emoji: emoji))
  }
  
  public static func markdown(_ text: String, verbatim: Bool? = nil) -> Self {
    .markdown(Markdown(text, verbatim: verbatim))
  }
  
  public var text: String {
    switch self {
    case .markdown(let md): return md.text
    case .plainText(let plain): return plain.text
    }
  }
}
