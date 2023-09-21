public struct Modal: View {
  
  fileprivate(set) public var type: String = "modal"
  
  public var title: PlainText
  public var blocks: [AnyBlock]
  
  public var submit: PlainText?
  public var close: PlainText?
  public var privateMetadata: String?
  public var callbackID: String?
  public var clearOnClose: Bool?
  public var notifyOnClose: Bool?
  public var externalID: String?
  public var submitDisabled: Bool?
  
  public init(
    _ callbackID: String,
    title: PlainText,
    submit: PlainText? = nil,
    close: PlainText? = nil,
    @BlocksBuilder blocks: () -> [AnyBlock]
  ) {
    self.callbackID = callbackID
    self.title = title
    self.submit = submit
    self.close = close
    self.blocks = blocks()
  }
  
  
  enum CodingKeys: String, CodingKey {
    case type
    case title
    case blocks
    case submit
    case close
    case privateMetadata = "private_metadata"
    case callbackID = "callback_id"
    case clearOnClose = "clear_on_close"
    case notifyOnClose = "notify_on_close"
    case externalID = "external_id"
    case submitDisabled = "submit_disabled"
  }
}
