extension SlackClient {
  
  public struct ChatDeleteResponse: Codable {
    var channel: ChannelID, ts: String
  }
  
  @discardableResult
  public func chatDelete(
    channel: ChannelID, ts: String
  ) async throws -> ChatDeleteResponse {
    let payload = Payload<EmptyCodable>(["channel": channel.rawValue, "ts": ts])
    let res = try await appClient
      .post(uri(for: "chat.delete"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ChatDeleteResponse>.self).get()
  }
}
