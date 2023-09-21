import struct Foundation.URL

public struct Button: Element {
  
  fileprivate(set) public var type: String = "button"
  
  public var text: PlainText
  public var actionID: String
  public var url: URL?
  public var value: String?
  public var style: Style?
  public var accessibilityLabel: String?
  
  public init(
    text: PlainText,
    actionID: String,
    url: URL? = nil,
    value: String? = nil,
    style: Button.Style? = nil,
    accessibilityLabel: String? = nil
  ) {
    self.text = text
    self.actionID = actionID
    self.url = url
    self.value = value
    self.style = style
    self.accessibilityLabel = accessibilityLabel
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case text
    case actionID = "action_id"
    case url
    case value
    case style
    case accessibilityLabel = "accessibility_label"
  }
}

extension Button {
  public enum Style: String, Codable {
    case `default`, primary, danger
  }
}

extension Button: ConfirmarionShowable {}
