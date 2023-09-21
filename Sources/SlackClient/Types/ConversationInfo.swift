import SlackPrimaryTypes

public struct ConversationInfo: Codable {
  
  public var id: ChannelID
  public var name: String
  public var nameNormalized: String
  
  public var isChannel: Bool
  public var isGroup: Bool
  public var isIm: Bool
  public var isMpim: Bool
  
  public var isReadOnly: Bool?
  public var isPrivate: Bool
  public var isArchived: Bool
  public var isGeneral: Bool
  
  public var isMember: Bool?
  
  public var isShared: Bool
  public var isExtShared: Bool?
  public var isOrgShared: Bool?
  
  public var contextTeamID: TeamID?
  public var sharedTeamID: [TeamID]?
  public var pendingConnectedTeamID: [TeamID]?
  public var pendingShared: [String]
  public var isPendingExtShared: Bool?
  
  public var created: Double
  public var creator: UserID
  public var updated: Double
  public var lastRead: String
  
  public var topic: Topic
  public var purpose: Purpose
  public var previousNames: [String]
  public var numMembers: Int?
  public var locale: String?
  
  public var unlinked: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case nameNormalized = "name_normalized"
    case isChannel = "is_channel"
    case isGroup = "is_group"
    case isIm = "is_im"
    case isMpim = "is_mpim"
    case isReadOnly = "is_read_only"
    case isPrivate = "is_private"
    case isArchived = "is_archived"
    case isGeneral = "is_general"
    case isMember = "is_member"
    case isShared = "is_shared"
    case isExtShared = "is_ext_shared"
    case isOrgShared = "is_org_shared"
    case contextTeamID = "context_team_id"
    case sharedTeamID = "shared_team_id"
    case pendingConnectedTeamID = "pending_connected_team_id"
    case pendingShared = "pending_shared"
    case isPendingExtShared = "is_pending_ext_shared"
    case created
    case creator
    case updated
    case lastRead = "last_read"
    case topic
    case purpose
    case previousNames = "previous_names"
    case numMembers = "num_members"
    case locale
    case unlinked
  }
}
