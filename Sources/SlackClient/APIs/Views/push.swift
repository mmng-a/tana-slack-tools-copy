import BlockKitBuilder
import Vapor

extension SlackClient {
  
  public struct ViewsPushResponse: Content {}
  
  @discardableResult
  public func viewsPush(
    triggerID: String, view: Modal
  ) async throws -> ViewsPushResponse {
    let payload = Payload(["trigger_id": triggerID, "view": view])
    let res = try await appClient
      .post(uri(for: "views.push"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ViewsPushResponse>.self).get()
  }
}
