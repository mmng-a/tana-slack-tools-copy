import Foundation
import SlackPrimaryTypes

extension SlackClient {
  
  public enum ReactionsGetResponse: Codable {
    case message(Message)
    
    public enum CodingKeys: CodingKey {
      case type
      case message
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let type = try container.decode(String.self, forKey: .type)
      switch type {
      case "message":
        let message = try container.decode(Message.self, forKey: .message)
        self = .message(message)
      default: fatalError("not implemented")
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .message(let message):
        try message.encode(to: encoder)
        try container.encode("message", forKey: .type)
      }
    }
    
    public struct Reaction: Codable {
      public var name: String
      public var users: [UserID]
      public var count: Int
    }
    
    public struct Message: Codable {
      public let type: String
      public var text: String
      public var user: UserID
      public var ts: String
      public var team: TeamID
      public var reactions: [Reaction]
      public var permalink: URL
    }
  }
  
  public func reactionsGet(
    channel: ChannelID, ts: String, full: Bool? = nil
  ) async throws -> ReactionsGetResponse.Message {
    let payload = Payload(["channel": channel.rawValue, "timestamp": ts, "full": full])
    let res = try await appClient
      .get(uri(for: "reactions.get"), headers: authedHeaders, beforeSend: { request in
        try request.query.encode(payload)
      })
    let response = try res.content.decode(SlackResult<ReactionsGetResponse>.self).get()
    if case .message(let message) = response {
      return message
    } else {
      throw SlackClientError.internalError
    }
  }
}
