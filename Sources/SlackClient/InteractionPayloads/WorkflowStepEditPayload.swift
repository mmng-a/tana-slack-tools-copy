import SlackPrimaryTypes

extension InteractionPayload {
  public struct WorkflowStepEdit: Decodable {
    public let type: String
    public let actionTS: String
    public let team: Team
    public let user: User
    public let callbackID: String
    public let triggerID: String
    public let workflowStep: WorkflowStep
    
    enum CodingKeys: String, CodingKey {
      case type = "type"
      case actionTS = "action_ts"
      case team = "team"
      case user = "user"
      case callbackID = "callback_id"
      case triggerID = "trigger_id"
      case workflowStep = "workflow_step"
    }
  }
}
