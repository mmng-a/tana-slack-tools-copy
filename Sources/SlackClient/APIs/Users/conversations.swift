import Vapor
import SlackPrimaryTypes

extension SlackClient {
  
  public func usersConversations(
    cursor: String? = nil,
    excludeArchived: Bool? = nil,
    limit: Int? = nil,
    teamID: String? = nil,
    types: [ChannelInfo.ChannelType] = [],
    user: UserID? = nil
  ) async throws -> (channels: [ChannelInfo], nextCursor: String?) {
    let typesStr = types.map(\.rawValue).joined(separator: ",")
    let payload = Payload([
      "cursor": cursor,
      "exclude_archived": excludeArchived,
      "limit": limit,
      "team_id": teamID,
      "types": typesStr,
      "user": user
    ])
    let res = try await appClient.get(
      uri(for: "users.conversations"),
      headers: authedHeaders,
      beforeSend: { req throws in try req.query.encode(payload) }
    )
    struct ChannelsContainer: Codable {
      var channels: [ChannelInfo]
      var response_metadata: ResponseMetadata?
      struct ResponseMetadata: Codable {
        var next_cursor: String?
      }
    }
    let decoded = try res.content.decode(SlackResult<ChannelsContainer>.self).get()
    return (channels: decoded.channels, nextCursor: decoded.response_metadata?.next_cursor)
  }
}
