import SlackPrimaryTypes

public struct UserGroup: Codable {
  public var id: UserGroupID
  public var teamID: TeamID
  public var isUsergroup: Bool
  public var name: String
  public var description: String
  public var handle: String
  public var isExternal: Bool
  public var dateCreate: Double
  public var dateUpdate: Double
  public var dateDelete: Double
  public var autoType: AutoType?
  public var createdBy: UserID
  public var updatedBy: UserID
  public var deletedBy: String?
  public var prefs: Prefs
  public var users: [String]
  public var userCount: String
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case teamID = "team_id"
    case isUsergroup = "is_usergroup"
    case name = "name"
    case description = "description"
    case handle = "handle"
    case isExternal = "is_external"
    case dateCreate = "date_create"
    case dateUpdate = "date_update"
    case dateDelete = "date_delete"
    case autoType = "auto_type"
    case createdBy = "created_by"
    case updatedBy = "updated_by"
    case deletedBy = "deleted_by"
    case prefs = "prefs"
    case users = "users"
    case userCount = "user_count"
  }
}

// MARK: - Prefs
extension UserGroup {
  public struct Prefs: Codable {
    public var channels: [ChannelID]
    public var groups: [ChannelID]
  }
}

extension UserGroup {
  public enum AutoType: String, Codable {
    case admins, owners
  }
}
