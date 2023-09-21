import BlockKitBuilder
import Foundation
import Vapor

extension SlackClient {
  
  public typealias ChatUpdateResponse = ChatPostMessageResponse
  
  public struct ChatUpdateOptions: Codable {
    public var as_user: Bool?
    public var attachments: String?
    public var blocks: [AnyBlock]?
    public var file_ids: [String]?
    public var link_names: Bool?
    public var metadata: String?
    public var parse: String?
    public var reply_broadcast: Bool?
    public var text: String?
    
    public init(as_user: Bool? = nil, attachments: String? = nil, blocks: [any Block]? = nil, file_ids: [String]? = nil, link_names: Bool? = nil, metadata: String? = nil, parse: String? = nil, reply_broadcast: Bool? = nil, text: String? = nil) {
      self.as_user = as_user
      self.attachments = attachments
      self.blocks = blocks.map { $0.map(AnyBlock.init) }
      self.file_ids = file_ids
      self.link_names = link_names
      self.metadata = metadata
      self.parse = parse
      self.reply_broadcast = reply_broadcast
      self.text = text
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encodeIfPresent(self.as_user, forKey: .as_user)
      try container.encodeIfPresent(self.attachments, forKey: .attachments)
      if let blocks = self.blocks {
        let encodedBlocks = try JSONEncoder().encode(blocks)
        let strBlocks = String(data: encodedBlocks, encoding: .utf8)!
        try container.encode(strBlocks, forKey: .blocks)
      }
      try container.encodeIfPresent(self.file_ids, forKey: .file_ids)
      try container.encodeIfPresent(self.link_names, forKey: .link_names)
      try container.encodeIfPresent(self.metadata, forKey: .metadata)
      try container.encodeIfPresent(self.parse, forKey: .parse)
      try container.encodeIfPresent(self.reply_broadcast, forKey: .reply_broadcast)
      try container.encodeIfPresent(self.text, forKey: .text)
    }
  }
  
  @discardableResult
  public func chatUpdate(
    channel: ChannelID, ts: String, options: ChatUpdateOptions
  ) async throws -> ChatUpdateResponse {
    let payload = Payload(options, options: ["channel": channel, "ts": ts])
    let res: ClientResponse = try await appClient
      .post(uri(for: "chat.update"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ChatUpdateResponse>.self).get()
  }
}
