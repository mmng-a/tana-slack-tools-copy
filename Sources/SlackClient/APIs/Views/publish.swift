import BlockKitBuilder
import Vapor

extension SlackClient {
  
  public struct ViewsPublishResponse: Codable {}
  
  @discardableResult
  public func viewsPublish(
    userID: UserID, view: HomeTab, hash: String? = nil
  ) async throws -> ViewsPublishResponse {
    let payload = Payload.init(["user_id": userID, "view": view, "hash": hash])
    let res = try await appClient
      .post(uri(for: "views.publish"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ViewsPublishResponse>.self).get()
  }
}
