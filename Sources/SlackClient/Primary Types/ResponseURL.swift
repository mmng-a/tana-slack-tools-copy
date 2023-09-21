import struct Foundation.URL

public struct ResponseURL: Codable {
  public var block_id: String
  public var action_id: String
  public var channel_id: ChannelID
  public var response_url: URL
}
