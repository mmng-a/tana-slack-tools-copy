public struct Team: Codable {
  public var id: TeamID
  public var domain: String
  public var enterpriseID: EnterpriseID?
  public var enterpriseName: String?
  
  public init(
    id: TeamID, domain: String, enterpriseID: EnterpriseID? = nil, enterpriseName: String? = nil
  ) {
    self.id = id
    self.domain = domain
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case domain
    case enterpriseID = "enterprise_id"
    case enterpriseName = "enterprise_name"
  }
}

public struct TeamID: SlackIDProtocol {
  
  public var rawValue: String
  
  public init(_ id: String) {
    self.rawValue = id
  }
}
