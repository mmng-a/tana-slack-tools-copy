import Vapor

public enum SlackResponseAction: Content {
  case errors([String: String])
  
  enum CodingKeys: CodingKey {
    case response_action
    case errors
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .errors(let errors):
      try container.encode("errors", forKey: .response_action)
      try container.encode(errors, forKey: .errors)
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let response_action = try container.decode(String.self, forKey: .response_action)
    switch response_action {
    case "errors": self = .errors(try container.decode([String: String].self, forKey: .errors))
    default:
      throw DecodingError.dataCorruptedError(forKey: CodingKeys.response_action, in: container, debugDescription: "unknown response_action '\(response_action)'")
    }
  }
}
