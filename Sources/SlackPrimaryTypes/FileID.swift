public struct FileID: SlackIDProtocol, Mention {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}

extension FileID: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "FileID(\"\(rawValue)\")"
  }
  
  public var debugDescription: String {
    "FileID(\"\(rawValue)\")"
  }
}
