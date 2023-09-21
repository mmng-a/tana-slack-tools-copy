extension EventPayload {
  public struct WorkflowStepExecute: Decodable {
    public var token: String
    public var teamID: String
    public var enterpriseID: String
    public var apiAppID: String
    public var event: Event
    public var type: String
    public var eventID: String
    public var eventTime: Int
    
    enum CodingKeys: String, CodingKey {
      case token = "token"
      case teamID = "team_id"
      case enterpriseID = "enterprise_id"
      case apiAppID = "api_app_id"
      case event = "event"
      case type = "type"
      case eventID = "event_id"
      case eventTime = "event_time"
    }
  }
}

extension EventPayload.WorkflowStepExecute {
  public struct Event: Codable {
    public var type: String
    public var callbackID: String
    public var workflowStep: WorkflowStep
    
    enum CodingKeys: String, CodingKey {
      case type = "type"
      case callbackID = "callback_id"
      case workflowStep = "workflow_step"
    }
  }
}

extension EventPayload.WorkflowStepExecute.Event {
  public struct WorkflowStep: Codable {
    public var workflowStepExecuteID: String
    public var inputs: [String: String]
    public var outputs: [Output]
    
    enum CodingKeys: String, CodingKey {
      case workflowStepExecuteID = "workflow_step_execute_id"
      case inputs = "inputs"
      case outputs = "outputs"
    }
  }
}

extension EventPayload.WorkflowStepExecute.Event.WorkflowStep {
  public struct Output: Codable {
    public var type: String
    public var name: String
    public var label: String
  }
}
