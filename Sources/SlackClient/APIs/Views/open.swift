import BlockKitBuilder
import Vapor

extension SlackClient {
  
  public struct ViewsOpenResponse: Codable {}
  
  @discardableResult
  public func viewsOpen(
    triggerID: String, view: Modal
  ) async throws -> ViewsOpenResponse {
    let payload = Payload(["trigger_id": triggerID, "view": view])
    let res = try await appClient
      .post(uri(for: "views.open"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ViewsOpenResponse>.self).get()
  }
  
  @discardableResult
  public func viewsOpen(
    triggerID: String, view: WorkflowStepModal
  ) async throws -> ViewsOpenResponse {
    let payload = Payload(["trigger_id": triggerID, "view": view])
    let res = try await appClient
      .post(uri(for: "views.open"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<ViewsOpenResponse>.self).get()
  }
}
