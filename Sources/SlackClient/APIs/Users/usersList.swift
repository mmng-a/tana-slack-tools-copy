import Vapor
import SlackPrimaryTypes

extension SlackClient {
  
  public func usersList(
    cursor: String? = nil,
    includeLocale: Bool? = nil,
    limit: Int? = nil,
    teamID: String? = nil
  ) async throws -> [UserInfo] {
    let payload = Payload([
      "cursor": cursor,
      "include_locale": includeLocale,
      "limit": limit,
      "team_id": teamID
    ])
    let res = try await appClient.get(
      uri(for: "users.list"),
      headers: authedHeaders,
      beforeSend: { req throws in try req.query.encode(payload) }
    )
    struct UsersContainer: Codable {
      var members: [UserInfo]
    }
    return try res.content.decode(SlackResult<UsersContainer>.self).get().members
  }
}
