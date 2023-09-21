import SlackPrimaryTypes
import Vapor

public struct EventPayload: Decodable {
  public var token: String
  public var teamID: TeamID
  public var apiAppID: String
  public var event: Event
  public var type: EventType
  public var eventID: String
  public var eventTime: Double
  
  public var authedUsers: [UserID]?
  public var authorizations: [Authorization]?
  public var isExtSharedChannel: Bool?
  
  enum CodingKeys: String, CodingKey {
    case token
    case teamID = "team_id"
    case apiAppID = "api_app_id"
    case event
    case type
    case eventID = "event_id"
    case eventTime = "event_time"
    
    case authedUsers = "authed_users"
    case authorizations
    case isExtSharedChannel = "is_ext_shared_channel"
  }
}

extension EventPayload {
  public enum EventType: String, Codable {
    case event_callback
  }
  
  public struct Authorization: Codable {
    public var enterpriseID: String?
    public var teamID: TeamID
    public var userID: UserID
    public var isBot: Bool
    public var isEnterpriseInstall: Bool?
    
    enum CodingKeys: String, CodingKey {
      case enterpriseID = "enterprise_id"
      case teamID = "team_id"
      case userID = "user_id"
      case isBot = "is_bot"
      case isEnterpriseInstall = "is_enterprise_Install"
    }
  }
}

extension EventPayload {
  public enum Event: Decodable {
    case appHomeOpened(AppHomeOpened)
    case workflowStepExecute(WorkflowStepExecute)
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: BasicCodingKey.self)
      let type = try container.decode(String.self, forKey: .key("type"))
      switch type {
      case "app_home_opened":
        self = .appHomeOpened(try AppHomeOpened(from: decoder))
      case "workflow_step_execute":
        self = .workflowStepExecute(try WorkflowStepExecute(from: decoder))
      default:
        throw DecodingError.dataCorruptedError(
          forKey: BasicCodingKey.key("type"), in: container,
          debugDescription: "unknown event type '\(type)'")
      }
    }
  }
}

