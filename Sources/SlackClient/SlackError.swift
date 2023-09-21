import AnyCodable
import Vapor

public enum SlackError: Error, Decodable {
  case noText
  case invalidTriggerID
  case notEnabled
  case messageTabDisabled
  case unknown(AnyDecodable)
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BasicCodingKey.self)
    let error = try container.decode(String.self, forKey: .key("error"))
    switch error {
    case "no_text":
      self = .noText
    case "invalid_trigger_id":
      self = .invalidTriggerID
    case "not_enabled":
      self = .notEnabled
    case "message_tab_disbaled":
      self = .messageTabDisabled
    default:
      self = .unknown(try AnyDecodable(from: decoder))
    }
  }
}
