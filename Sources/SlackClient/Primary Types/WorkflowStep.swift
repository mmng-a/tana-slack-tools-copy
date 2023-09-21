// MARK: - Welcome
public struct WorkflowStep: Codable {
  public var workflowStepExecuteID: String?
  public var workflowStepEditID: String?
  public var workflowInstanceID: String?
  public var workflowID: String
  public var stepID: String
  public var stepName: String?
  public var stepImageURL: String?
  public var inputs: [String: Input]
  public var outputs: [Output]
  
  enum CodingKeys: String, CodingKey {
    case workflowStepExecuteID = "workflow_step_execute_id"
    case workflowStepEditID = "workflow_step_edit_id"
    case workflowInstanceID = "workflow_instance_id"
    case workflowID = "workflow_id"
    case stepID = "step_id"
    case stepName = "step_name"
    case stepImageURL = "step_image_url"
    case inputs = "inputs"
    case outputs = "outputs"
  }
  
  public init(workflowStepExecuteID: String? = nil, workflowStepEditID: String? = nil, workflowInstanceID: String? = nil, workflowID: String, stepID: String, stepName: String? = nil, stepImageURL: String? = nil, inputs: [String : Input], outputs: [Output]) {
    self.workflowStepExecuteID = workflowStepExecuteID
    self.workflowStepEditID = workflowStepEditID
    self.workflowInstanceID = workflowInstanceID
    self.workflowID = workflowID
    self.stepID = stepID
    self.stepName = stepName
    self.stepImageURL = stepImageURL
    self.inputs = inputs
    self.outputs = outputs
  }
}

extension WorkflowStep {
  public struct Input: Codable {
    public var value: String // Any?
    public var skipVariableReplacement: Bool?
    public var variables: [String: String]?
    
    enum CodingKeys: String, CodingKey {
      case value = "value"
      case skipVariableReplacement = "skip_variable_replacement"
      case variables = "variables"
    }
    
    public init(value: String, skipVariableReplacement: Bool? = nil, variables: [String: String]? = nil) {
      self.value = value
      self.skipVariableReplacement = skipVariableReplacement
      self.variables = variables
    }
  }
}

// MARK: - Output
extension WorkflowStep {
  public struct Output: Codable {
    public var name: String
    public var type: String
    public var label: String
    
    enum CodingKeys: String, CodingKey {
      case name = "name"
      case type = "type"
      case label = "label"
    }
    
    public init(name: String, type: String, label: String) {
      self.name = name
      self.type = type
      self.label = label
    }
  }
}
