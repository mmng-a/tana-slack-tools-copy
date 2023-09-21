import BlockKitBuilder
import Vapor

extension SlackClient {
  
  public struct ChatPostMessageResponse: Content {
    public var channel: ChannelID
    public var ts: String
  }
  
  public struct ChatPostMessageOptions: Codable {
    public var as_user: Bool?
    public var icon_emoji: String?
    public var icon_url: String?
    public var link_names: Bool?
    public var metadata: Metadata?
    public var mrkdwn: Bool?
    public var parse: String?
    public var reply_broadcast: Bool?
    public var thread_ts: String?
    public var unfurl_links: Bool?
    public var unfurl_media: Bool?
    public var username: String?
    
    public init(as_user: Bool? = nil, icon_emoji: String? = nil, icon_url: String? = nil, link_names: Bool? = nil, metadata: Metadata? = nil, mrkdwn: Bool? = nil, parse: String? = nil, reply_broadcast: Bool? = nil, thread_ts: String? = nil, unfurl_links: Bool? = nil, unfurl_media: Bool? = nil, username: String? = nil) {
      self.as_user = as_user
      self.icon_emoji = icon_emoji
      self.icon_url = icon_url
      self.link_names = link_names
      self.metadata = metadata
      self.mrkdwn = mrkdwn
      self.parse = parse
      self.reply_broadcast = reply_broadcast
      self.thread_ts = thread_ts
      self.unfurl_links = unfurl_links
      self.unfurl_media = unfurl_media
      self.username = username
    }
  }
  
  
  @discardableResult
  public func chatPostMessage(
    channel: ChannelID, text: String, options: ChatPostMessageOptions = .init()
  ) async throws -> ChatPostMessageResponse {
    let payload = Payload(options, options: ["channel": channel.rawValue, "text": text])
    let res: ClientResponse = try await appClient
      .post(uri(for: "chat.postMessage"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ChatPostMessageResponse>.self).get()
  }
  
  @discardableResult
  public func chatPostMessage(
    channel: ChannelID, message: Message, text: String?, options: ChatPostMessageOptions = .init()
  ) async throws -> ChatPostMessageResponse {
    try await chatPostMessage(channel: channel, blocks: message.blocks, text: text, options: options)
  }
  
  @discardableResult
  public func chatPostMessage(
    channel: ChannelID, text: String?, options: ChatPostMessageOptions = .init(), @BlocksBuilder blocks: () -> [AnyBlock]
  ) async throws -> ChatPostMessageResponse {
    try await chatPostMessage(channel: channel, blocks: blocks(), text: text, options: options)
  }
  
  @discardableResult
  public func chatPostMessage(
    channel: ChannelID, blocks: [any Block], text: String?, options: ChatPostMessageOptions = .init()
  ) async throws -> ChatPostMessageResponse {
    let encodedBlock = try JSONEncoder().encode(blocks.map(AnyBlock.init))
    let payload = Payload(options, options: [
      "channel": channel.rawValue,
      "blocks": String(data: encodedBlock, encoding: .utf8)!,
      "text": text
    ])
    let res: ClientResponse = try await appClient
      .post(uri(for: "chat.postMessage"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ChatPostMessageResponse>.self).get()
  }
}
