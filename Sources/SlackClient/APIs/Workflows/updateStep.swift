import Vapor
import Foundation

extension SlackClient {
  
  public struct WorkflowsUpdateStepResponse: Decodable {}
  
  @discardableResult
  public func workflowsUpdateStep(
    workflowStepEditID editID: String,
    inputs: [String: WorkflowStep.Input]? = nil,
    outputs: [WorkflowStep.Output]? = nil,
    stepImageURL: URI? = nil,
    stepName: String? = nil
  ) async throws -> WorkflowsUpdateStepResponse {
    let payload = Payload([
      "workflow_step_edit_id": editID,
      "inputs": inputs,
      "outputs": outputs,
      "step_image_url": stepImageURL,
      "step_name": stepName,
    ])
    print(String(data: try JSONEncoder().encode(payload), encoding: .utf8)!)
    let res = try await appClient
      .post(uri(for: "workflows.updateStep"), headers: authedHeaders, content: payload)
    return try res.content.decode(SlackResult<WorkflowsUpdateStepResponse>.self).get()
  }
}
