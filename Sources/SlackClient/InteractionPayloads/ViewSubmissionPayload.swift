import BlockKitBuilder
import SlackPrimaryTypes
import Vapor

extension InteractionPayload {
  public struct ViewSubmission: Codable {
    public let team: Team
    public let user: User
    public let api_app_id: String
    public let token: String
    public let trigger_id: String
    public let view: ResponedView
    public let response_urls: [ResponseURL]
  }
}
