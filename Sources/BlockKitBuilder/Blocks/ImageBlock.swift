import Foundation

public struct ImageBlock: Block {
  
  fileprivate(set) public var type: String = "image"
  
  var imageUrl: URL
  var altText: String?
  var title: PlainText?
  
  enum CodingKeys: String, CodingKey {
    case type
    case imageUrl = "image_url"
    case altText = "alt_text"
    case title
  }
}
