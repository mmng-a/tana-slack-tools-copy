import SlackPrimaryTypes

public typealias ResponedMessage = Payload<SimpleMessage>
public struct SimpleMessage: Codable {
  public var type: String
  public var user: UserID?
  public var ts: String
  public var text: String?
  public var metadata: Metadata?
  public var threadTS: String?
  
  enum CodingKeys: String, CodingKey {
    case type
    case user
    case ts
    case text
    case metadata
    case threadTS = "thread_ts"
  }
}

struct _ResponedMessage: Codable {
  public let type: String
  public let bot_id: String
  public let text: String
  public let user: UserID
  public let ts: String
  public let metadata: Metadata?
  public let app_id: String
  public let team: TeamID
  public let thread_ts: String?
  public let parent_user_id: UserID?
}
