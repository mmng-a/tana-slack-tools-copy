// MARK: - UserID
public struct UserID: SlackIDProtocol, Mention {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}

// MARK: - User
public struct User: Codable {
  public var id: UserID
  public var name: String
  public var teamID: TeamID?
  
  public init(id: UserID, name: String, teamID: TeamID? = nil) {
    self.id = id
    self.name = name
    self.teamID = teamID
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case username
    case teamID = "team_id"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(UserID.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
      ?? container.decode(String.self, forKey: .username)
    self.teamID = try container.decodeIfPresent(TeamID.self, forKey: .teamID)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(teamID, forKey: .teamID)
  }
}

extension UserID: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "<@\(rawValue)>"
  }
  
  public var debugDescription: String {
    "UserID(@\(rawValue))"
  }
}


