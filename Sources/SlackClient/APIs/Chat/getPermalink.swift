import Vapor

extension SlackClient {
  
  public struct ChatGetPermalinkResponse: Content {
    var permalink: URI
  }
  
  public func chatGetPermalink(
    channel: ChannelID, messageTS: String
  ) async throws -> ChatGetPermalinkResponse {
    let payload = Payload(["channel": channel, "message_ts": messageTS])
    let res: ClientResponse = try await appClient
      .post(uri(for: "chat.getPermalink"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ChatGetPermalinkResponse>.self).get()
  }
}
