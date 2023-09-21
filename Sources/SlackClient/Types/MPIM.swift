import SlackPrimaryTypes

public typealias MultipleUserDirectMessage = MPIM

public struct MPIM: Codable {
  public var id: String
  public var name: String
  public var isMpim: Bool
  public var isGroup: Bool
  public var created: Double
  public var creator: UserID
  public var members: [UserID]
  public var lastRead: String
//  public var latest:
  public var unreadCount: Int
  public var unreadCountDisplay: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
    case isMpim = "is_mpim"
    case isGroup = "is_group"
    case created = "created"
    case creator = "creator"
    case members = "members"
    case lastRead = "last_read"
//    case latest = "latest"
    case unreadCount = "unread_count"
    case unreadCountDisplay = "unread_count_display"
  }
}
