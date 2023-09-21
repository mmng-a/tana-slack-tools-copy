import SlackPrimaryTypes

public struct ChannelInfo: Codable {
  
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
  public var lastRead: String?
  
  public var topic: Topic
  public var purpose: Purpose
  public var previousNames: [String]
  
  public var unlinked: Int?
  
  // public let latest: message
  public var unreadCount: Int?
  public var unreadCountDisplay: Int?
  public var members: [UserID]?
  
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
    case unlinked
    case unreadCount = "unread_count"
    case unreadCountDisplay = "unread_count_display"
    case members = "members"
  }
}

extension ChannelInfo {
  var channel: Channel {
    Channel(id: id, name: name)
  }
}

extension ChannelInfo {
  public enum ChannelType: String, Codable, Equatable, Hashable {
    case publicChannel = "public_channel"
    case privateChannel = "private_channel"
    case mpim = "mpim"
    case im = "im"
  }
  
  public var channelType: ChannelType {
    if isChannel && !isPrivate {
      return .publicChannel
    } else if isChannel {
      return .privateChannel
    } else if isIm {
      return .im
    } else if isMpim {
      return .mpim
    } else {
      return .publicChannel
    }
  }
}
