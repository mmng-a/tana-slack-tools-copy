public struct HomeTab: Codable {
  private var type = "home"
  public var blocks: [AnyBlock]
  public var private_metadata: String?
  public var callback_id: String?
  public var external_id: String?
  
  public init(callback_id: String, @BlocksBuilder blocks: () -> [AnyBlock]) {
    self.blocks = blocks()
    self.callback_id = callback_id
  }
}
