import Vapor

extension SlackClient {
  @discardableResult
  public func conversationsInvite(
    channel: ChannelID, users: [UserID]
  ) async throws -> ChannelInfo {
    let payload = Payload(["channel": channel, "users": users])
    let res = try await appClient
      .post(uri(for: "conversations.invite"), headers: authedHeaders, content: payload)
    struct ChannelContainer: Codable { var channel: ChannelInfo }
    return try res.content.decode(SlackResult<ChannelContainer>.self).get().channel
  }
}
