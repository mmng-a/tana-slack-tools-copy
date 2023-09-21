public struct WorkflowStepModal: Codable {
  fileprivate(set) public var type: String = "workflow_step"
  
  public var blocks: [AnyBlock]
  
  public var privateMetadata: String?
  public var callbackID: String?
  public var clearOnClose: Bool?
  public var notifyOnClose: Bool?
  public var externalID: String?
  public var submitDisabled: Bool?
  
  public init(
    _ callbackID: String,
    @BlocksBuilder blocks: () -> [AnyBlock]
  ) {
    self.callbackID = callbackID
    self.blocks = blocks()
  }
  
  
  enum CodingKeys: String, CodingKey {
    case type
    case blocks
    case privateMetadata = "private_metadata"
    case callbackID = "callback_id"
    case clearOnClose = "clear_on_close"
    case notifyOnClose = "notify_on_close"
    case externalID = "external_id"
    case submitDisabled = "submit_disabled"
  }
}
