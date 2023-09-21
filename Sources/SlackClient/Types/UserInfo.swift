import SlackPrimaryTypes

public struct UserInfo: Codable {
  public var id: UserID
  public var teamID: TeamID
  public var name: String
  public var deleted: Bool?
  public var color: String?
  public var realName: String?
  public var tz: String?
  public var tzLabel: String?
  public var tzOffset: Int?
  public var profile: Profile
  public var isAdmin: Bool?
  public var isOwner: Bool?
  public var isPrimaryOwner: Bool?
  public var isRestricted: Bool?
  public var isUltraRestricted: Bool?
  public var isBot: Bool?
  public var isAppUser: Bool?
  public var updated: Int?
  public var isEmailConfirmed: Bool?
  public var whoCanShareContactCard: String?
  public var enterpriseUser: EnterpriseUser?
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case teamID = "team_id"
    case name = "name"
    case deleted = "deleted"
    case color = "color"
    case realName = "real_name"
    case tz = "tz"
    case tzLabel = "tz_label"
    case tzOffset = "tz_offset"
    case profile = "profile"
    case isAdmin = "is_admin"
    case isOwner = "is_owner"
    case isPrimaryOwner = "is_primary_owner"
    case isRestricted = "is_restricted"
    case isUltraRestricted = "is_ultra_restricted"
    case isBot = "is_bot"
    case isAppUser = "is_app_user"
    case updated = "updated"
    case isEmailConfirmed = "is_email_confirmed"
    case whoCanShareContactCard = "who_can_share_contact_card"
    case enterpriseUser = "enterprise_user"
  }
}

// MARK: - EnterpriseUser
extension UserInfo {
  public struct EnterpriseUser: Codable {
    public var id: UserID
    public var enterpriseID: String
    public var enterpriseName: String
    public var isAdmin: Bool
    public var isOwner: Bool
    public var isPrimaryOwner: Bool
    public var teams: [TeamID]
    
    enum CodingKeys: String, CodingKey {
      case id = "id"
      case enterpriseID = "enterprise_id"
      case enterpriseName = "enterprise_name"
      case isAdmin = "is_admin"
      case isOwner = "is_owner"
      case isPrimaryOwner = "is_primary_owner"
      case teams = "teams"
    }
  }
}

// MARK: - Profile
extension UserInfo {
  public struct Profile: Codable {
    public var title: String?
    public var phone: String?
    public var skype: String?
    public var realName: String?
    public var realNameNormalized: String?
    public var displayName: String?
    public var displayNameNormalized: String?
    public var fields: [String: Field]?
    public var statusText: String?
    public var statusEmoji: String?
    public var statusEmojiDisplayInfo: [StatusEmojiDisplayInfo]?
    public var statusExpiration: Int?
    public var avatarHash: String?
    public var startDate: Double?
    public var imageOriginal: String?
    public var isCustomImage: Bool?
    public var email: String?
    public var pronouns: String?
    public var huddleState: String?
    public var huddleStateExpirationTs: Int?
    public var firstName: String?
    public var lastName: String?
    public var image24: String?
    public var image32: String?
    public var image48: String?
    public var image72: String?
    public var image192: String?
    public var image512: String?
    public var image1024: String?
    public var statusTextCanonical: String?
    public var team: TeamID
    
    enum CodingKeys: String, CodingKey {
      case title = "title"
      case phone = "phone"
      case skype = "skype"
      case realName = "real_name"
      case realNameNormalized = "real_name_normalized"
      case displayName = "display_name"
      case displayNameNormalized = "display_name_normalized"
      case fields = "fields"
      case statusText = "status_text"
      case statusEmoji = "status_emoji"
      case statusEmojiDisplayInfo = "status_emoji_display_info"
      case statusExpiration = "status_expiration"
      case avatarHash = "avatar_hash"
      case startDate = "start_date"
      case imageOriginal = "image_original"
      case isCustomImage = "is_custom_image"
      case email = "email"
      case pronouns = "pronouns"
      case huddleState = "huddle_state"
      case huddleStateExpirationTs = "huddle_state_expiration_ts"
      case firstName = "first_name"
      case lastName = "last_name"
      case image24 = "image_24"
      case image32 = "image_32"
      case image48 = "image_48"
      case image72 = "image_72"
      case image192 = "image_192"
      case image512 = "image_512"
      case image1024 = "image_1024"
      case statusTextCanonical = "status_text_canonical"
      case team = "team"
    }
  }
}

extension UserInfo.Profile {
  public struct Field: Codable {
    public var value: String
    public var alt: String
  }
  
  public struct StatusEmojiDisplayInfo: Codable {
    public var emojiName: String
    public var displayURL: String
    
    enum CodingKeys: String, CodingKey {
      case emojiName = "emoji_name"
      case displayURL = "display_url"
    }
  }
}
