import struct Foundation.Date

// MARK: - ChannelID
public struct ChannelID: SlackIDProtocol {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}

extension ChannelID: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "<#\(rawValue)>"
  }
  
  public var debugDescription: String {
    "ChannelID(#\(rawValue))"
  }
}

// MARK: - Channel
public struct Channel: Codable {
  public var id: ChannelID
  public var name: String
  
  public init(id: ChannelID, name: String) {
    self.id = id
    self.name = name
  }
}
