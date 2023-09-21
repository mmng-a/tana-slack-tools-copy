import SlackPrimaryTypes

extension InteractionPayload {
  public struct MessageAction: Decodable {
    public let type: String
    public let callbackID: String
    public let triggerID: String
    public let messageTS: String
    public let responseURL: String
    public let message: Payload<Message>
    public let user: User
    public let channel: Channel
    public let team: Team?
    public let token: String
    public let actionTS: String
    
    public let isEnterpriseInstall: Bool?
    public let enterprise: Enterprise?
    
    enum CodingKeys: String, CodingKey {
      case type = "type"
      case callbackID = "callback_id"
      case triggerID = "trigger_id"
      case messageTS = "message_ts"
      case responseURL = "response_url"
      case message = "message"
      case user = "user"
      case channel = "channel"
      case team = "team"
      case token = "token"
      case actionTS = "action_ts"
      case isEnterpriseInstall = "is_enterprise_install"
      case enterprise = "enterprise"
    }
    public struct Message: Codable {
      public let type: String
      public let user: UserID?
      public let ts: String
      public let text: String?
    }

  }
}
