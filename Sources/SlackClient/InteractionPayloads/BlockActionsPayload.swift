import BlockKitBuilder
import SlackPrimaryTypes
import struct Vapor.URI

// MARK: - BlockActions
extension InteractionPayload {
  public struct BlockAction: Decodable {
    public let type: String
    public let actions: [Self.Action]
    public let team: Team
    public let user: User
    public let channel: Channel?
    public let message: ResponedMessage?
    public let token: String
    public let container: Container
    public let triggerID: String
    public let view: ResponedView?
    public let responseURL: URI?
    
    enum CodingKeys: String, CodingKey {
      case type
      case actions
      case team
      case user
      case channel
      case message
      case token
      case container
      case triggerID = "trigger_id"
      case view
      case responseURL = "response_url"
    }
  }
}

public extension InteractionPayload.BlockAction {
  enum Container: Codable {
    case view(viewID: String)
    case message(channelID: ChannelID, messageTS: String, threadTS: String?)
    
    enum CodingKeys: CodingKey {
      case type
      case view_id
      case message_ts
      case channel_id
      case thread_ts
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let type = try container.decode(String.self, forKey: .type)
      switch type {
      case "view":
        let id = try container.decode(String.self, forKey: .view_id)
        self = .view(viewID: id)
      case "message":
        let ts = try container.decode(String.self, forKey: .message_ts)
        let channel = try container.decode(ChannelID.self, forKey: .channel_id)
        let threadTS = try container.decodeIfPresent(String.self, forKey: .thread_ts)
        self = .message(channelID: channel, messageTS: ts, threadTS: threadTS)
      default:
        throw DecodingError.dataCorruptedError(
          forKey: CodingKeys.type, in: container,
          debugDescription: "unknown type '\(type)'")
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .view(let viewID):
        try container.encode("view", forKey: .type)
        try container.encode(viewID, forKey: .view_id)
      case .message(let channelID, let messageTS, let threadTS):
        try container.encode("message", forKey: .type)
        try container.encode(channelID, forKey: .channel_id)
        try container.encode(messageTS, forKey: .message_ts)
        try container.encodeIfPresent(threadTS, forKey: .thread_ts)
      }
    }
  }
}
