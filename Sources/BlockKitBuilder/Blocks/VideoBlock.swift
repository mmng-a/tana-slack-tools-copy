import struct Foundation.URL

public struct VideoBlock: Block {
  
  fileprivate(set) public var type: String = "video"
  
  var altText: String
  var authorName: String?
  var description: PlainText?
  var providerIconUrl: URL?
  var providerName: String?
  var title: String
  var titleUrl: URL?
  var thumbnailUrl: URL
  var videoUrl: URL
  
  init(
    title: String,
    authorName: String? = nil,
    videoUrl: URL,
    description: PlainText? = nil,
    thumbnailUrl: URL,
    altText: String,
    providerIconUrl: URL? = nil,
    providerName: String? = nil,
    titleUrl: URL? = nil
  ) {
    self.altText = altText
    self.authorName = authorName
    self.description = description
    self.providerIconUrl = providerIconUrl
    self.providerName = providerName
    self.title = title
    self.titleUrl = titleUrl
    self.thumbnailUrl = thumbnailUrl
    self.videoUrl = videoUrl
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case altText = "alt_text"
    case authorName = "author_name"
    case description = "description"
    case providerIconUrl = "provider_icon_url"
    case providerName = "provider_name"
    case title = "title"
    case titleUrl = "title_url"
    case thumbnailUrl = "thumbnail_url"
    case videoUrl = "video_url"
  }
}
