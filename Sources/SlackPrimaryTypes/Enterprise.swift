public struct EnterpriseID: SlackIDProtocol, Mention {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}

extension EnterpriseID: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "EnterpriseID(\"\(rawValue)\")"
  }
  
  public var debugDescription: String {
    "EnterpriseID(\"\(rawValue)\")"
  }
}


public struct Enterprise: Codable {
  public var id: EnterpriseID
  public var name: String
  
  public init(id: EnterpriseID, name: String) {
    self.id = id
    self.name = name
  }
}
