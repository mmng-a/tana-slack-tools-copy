public struct UserGroupID: SlackIDProtocol, Mention {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}

extension UserGroupID: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "<!subteam^\(rawValue)>"
  }
  
  public var debugDescription: String {
    "UserGroupID(!\(rawValue))"
  }
}
