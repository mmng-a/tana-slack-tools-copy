import Vapor
import SlackPrimaryTypes

public struct SlashCommandPayload: Content {
  @available(*, deprecated) public let token: String
  public let command: String
  public let text: String
  public let response_url: URI
  public let trigger_id: String
  public let user_id: UserID
  @available(*, deprecated) public let user_name: String?
  public let team_id: TeamID
  public let enterprise_id: String?
  public let channel_id: ChannelID
  public let api_app_id: String
}
