import SlackPrimaryTypes

public typealias DirectMessage = IΜ

public struct IΜ: Codable {
  public var id: String
  public var isIm: Bool
  public var user: UserID
  public var created: Double
  public var isUserDeleted: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case isIm = "is_im"
    case user = "user"
    case created = "created"
    case isUserDeleted = "is_user_deleted"
  }
}
