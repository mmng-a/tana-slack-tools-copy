import Vapor

public enum InteractionPayload: Decodable {
  case blockActions(BlockAction)
  case viewSubmission(ViewSubmission)
  case viewClosed
  case shortcut(Shortcut)
  case messageAction
  case workflowStepEdit(WorkflowStepEdit)
}

extension InteractionPayload {
  
  enum TypeCodingKeys: String, CodingKey { case type }
  
  public init(from decoder: Decoder) throws {
    let typeContainer = try decoder.container(keyedBy: TypeCodingKeys.self)
    let type = try typeContainer.decode(String.self, forKey: .type)
    switch type {
    case "block_actions":
      self = .blockActions(try BlockAction(from: decoder))
    case "view_submission":
      self = .viewSubmission(try ViewSubmission(from: decoder))
    case "view_closed":
      self = .viewClosed
    case "shortcut":
      self = .shortcut(try Shortcut(from: decoder))
    case "messageAction":
      self = .messageAction
    case "workflow_step_edit":
      self = .workflowStepEdit(try WorkflowStepEdit(from: decoder))
    default:
      throw DecodingError.dataCorruptedError(
        forKey: TypeCodingKeys.type, in: typeContainer,
        debugDescription: "'\(type)' is unknown type")
    }
  }
}
