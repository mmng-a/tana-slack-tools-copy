import Vapor

extension EventPayload {
  public struct AppHomeOpened: Codable {
    public var type: String { "app_home_opened" }
    public var user: UserID
    public var channel: ChannelID
    public var event_ts: String
    public var tab: TabType
    public var view: ResponedView?
    
    public enum TabType: String, Codable {
      case home, messages
    }
  }
}
