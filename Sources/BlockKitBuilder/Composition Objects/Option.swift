import struct Foundation.URL

public struct Option: Codable {
  
  public var text: Text
  public var value: String
  public var description: PlainText?
  public var url: URL?
  
  public init(
    _ text: Text,
    value: String,
    description: PlainText? = nil,
    url: URL? = nil
  ) {
    self.text = text
    self.value = value
    self.description = description
    self.url = url
  }
  
  public init(
    _ text: String,
    value: String,
    description: PlainText? = nil,
    url: URL? = nil
  ) {
    self.text = Text.plainText(PlainText(text))
    self.value = value
    self.description = description
    self.url = url
  }
}
