import SlackPrimaryTypes

public struct Purpose: Codable {
  public var value: String
  public var creator: UserID
  public var lastSet: Double
  
  enum CodingKeys: String, CodingKey {
    case value
    case creator
    case lastSet = "last_set"
  }
}
