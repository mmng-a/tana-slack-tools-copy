import AnyCodable

public struct Metadata: Codable {
  public var eventType: String
  public var eventPayload: AnyCodable
  
  enum CodingKeys: String, CodingKey {
    case eventType = "event_type"
    case eventPayload = "event_payload"
  }
  
  public init(eventType: String, eventPayload: any Codable) {
    self.eventType = eventType
    self.eventPayload = AnyCodable(eventPayload)
  }
}
