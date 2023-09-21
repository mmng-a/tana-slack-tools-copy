public struct DispatchActionConfig: Codable, OptionSet {
  public let rawValue: Int
  
  public static let onEnterPressed = Self(rawValue: 1 << 0)
  public static let onCharacterEntered = Self(rawValue: 1 << 1)
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static var none: Self { Self() }
}

extension DispatchActionConfig {
  enum CodingKeys: String, CodingKey {
    case triggerActionsOn = "trigger_actions_on"
  }
  
  public func encode(to encoder: Encoder) throws {
    var array: [String] = []
    if self.contains(.onEnterPressed) { array.append("on_enter_pressed") }
    if self.contains(.onCharacterEntered) { array.append("on_character_entered") }
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(array, forKey: .triggerActionsOn)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let array = try container.decode([String].self, forKey: .triggerActionsOn)
    var config = Self()
    if array.contains("on_enter_pressed") { config.insert(.onEnterPressed) }
    if array.contains("on_character_entered") { config.insert(.onCharacterEntered) }
    self = config
  }
}
