import SlackPrimaryTypes

extension InteractionPayload {
  
  typealias GlobalShortcut = Shortcut
  public struct Shortcut: Decodable {
    public let type: String
    public let callbackID: String
    public let triggerID: String
    public let user: User
    public let team: Team?
    public let token: String
    public let actionTS: String
    
    public let isEnterpriseInstall: Bool?
    public let enterprise: Enterprise?
    
    enum CodingKeys: String, CodingKey {
      case type = "type"
      case callbackID = "callback_id"
      case triggerID = "trigger_id"
      case user = "user"
      case team = "team"
      case token = "token"
      case actionTS = "action_ts"
      case isEnterpriseInstall = "is_enterprise_install"
      case enterprise = "enterprise"
    }
  }
}
