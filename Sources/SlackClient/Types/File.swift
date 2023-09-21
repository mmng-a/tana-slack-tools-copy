import SlackPrimaryTypes

public struct File: Codable {
  
  public var id: FileID
  public var created: Double
  public var timestamp: Double
  public var name: String
  public var title: String
  
  public var mimetype: String
  public var filetype: String
  public var prettyType: String
  
  public var user: UserID
  public var editable: Bool
  public var size: Int
  public var mode: String
  public var isExternal: Bool
  public var externalType: String
  public var isPublic: Bool
  public var publicURLShared: Bool
  public var displayAsBot: Bool
  public var username: String
  public var urlPrivate: String
  public var urlPrivateDownload: String
  public var thumb64: String
  public var thumb80: String
  public var thumb360: String
  public var thumb360_W: Int
  public var thumb360_H: Int
  public var thumb160: String
  public var thumb360_GIF: String
  public var imageExifRotation: Int
  public var originalW: Int
  public var originalH: Int
  public var deanimateGIF: String
  public var pjpeg: String
  public var permalink: String
  public var permalinkPublic: String
  public var commentsCount: Int
  public var isStarred: Bool
  public var shares: Shares
  public var channels: [ChannelID]
  public var groups: [String]
  public var ims: [String]
  public var hasRichPreview: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case created = "created"
    case timestamp = "timestamp"
    case name = "name"
    case title = "title"
    case mimetype = "mimetype"
    case filetype = "filetype"
    case prettyType = "pretty_type"
    case user = "user"
    case editable = "editable"
    case size = "size"
    case mode = "mode"
    case isExternal = "is_external"
    case externalType = "external_type"
    case isPublic = "is_public"
    case publicURLShared = "public_url_shared"
    case displayAsBot = "display_as_bot"
    case username = "username"
    case urlPrivate = "url_private"
    case urlPrivateDownload = "url_private_download"
    case thumb64 = "thumb_64"
    case thumb80 = "thumb_80"
    case thumb360 = "thumb_360"
    case thumb360_W = "thumb_360_w"
    case thumb360_H = "thumb_360_h"
    case thumb160 = "thumb_160"
    case thumb360_GIF = "thumb_360_gif"
    case imageExifRotation = "image_exif_rotation"
    case originalW = "original_w"
    case originalH = "original_h"
    case deanimateGIF = "deanimate_gif"
    case pjpeg = "pjpeg"
    case permalink = "permalink"
    case permalinkPublic = "permalink_public"
    case commentsCount = "comments_count"
    case isStarred = "is_starred"
    case shares = "shares"
    case channels = "channels"
    case groups = "groups"
    case ims = "ims"
    case hasRichPreview = "has_rich_preview"
  }
}

extension File {
  
  // MARK: - Shares
  public struct Shares: Codable {
    public var `public`: [ChannelID: PublicInner]
    
    enum CodingKeys: String, CodingKey {
      case `public` = "public"
    }
  }
  
  // MARK: - PublicInner
  public struct PublicInner: Codable {
    public var replyUsers: [String]
    public var replyUsersCount: Int
    public var replyCount: Int
    public var ts: String
    public var threadTs: String
    public var latestReply: String
    public var channelName: String
    public var teamID: TeamID
    
    enum CodingKeys: String, CodingKey {
      case replyUsers = "reply_users"
      case replyUsersCount = "reply_users_count"
      case replyCount = "reply_count"
      case ts = "ts"
      case threadTs = "thread_ts"
      case latestReply = "latest_reply"
      case channelName = "channel_name"
      case teamID = "team_id"
    }
  }
}

// MARK: - FileType
extension File {
  public enum FileType: String, Codable {
    case auto, text, ai, apk, applescript, binary, bmp, boxnote, c, csharp, cpp, css, csv, clojure, coffeescript, cfm, d, dart, diff, doc, docx, dockerfile, dotx, email, eps, epub, erlang, fla, flv, fsharp, fortran, gdoc, gdraw, gif, go, gpres, groovy, gsheet, gzip, html, handlebars, haskell, haxe, indd, java, javascript, jpg, json, keynote, kotlin, latex, lisp, lua, m4a, markdown, matlab, mhtml, mkv, mov, mp3, mp4, mpg, mumps, numbers, nzb, objc, ocaml, odg, odi, odp, ods, odt, ogg, ogv, pages, pascal, pdf, perl, php, pig, png, post, powershell, ppt, pptx, psd, puppet, python, qtz, r, rtf, ruby, rust, sql, sass, scala, scheme, sketch, shell, smalltalk, svg, swf, swift, tar, tiff, tsv, vb, vbscript, vcard, velocity, verilog, wav, webm, wmv, xls, xlsx, xlsb, xlsm, xltx, xml, yaml, zip
    
    public var description: String {
      switch self {
      case .auto: return "Auto Detect Type"
      case .text: return "Plain Text"
      case .ai: return "Illustrator File"
      case .apk: return "APK"
      case .applescript: return "AppleScript"
      case .binary: return "Binary"
      case .bmp: return "Bitmap"
      case .boxnote: return "BoxNote"
      case .c: return "C"
      case .csharp: return "C#"
      case .cpp: return "C++"
      case .css: return "CSS"
      case .csv: return "CSV"
      case .clojure: return "Clojure"
      case .coffeescript: return "CoffeeScript"
      case .cfm: return "ColdFusion"
      case .d: return "D"
      case .dart: return "Dart"
      case .diff: return "Diff"
      case .doc: return "Word Document"
      case .docx: return "Word document"
      case .dockerfile: return "Docker"
      case .dotx: return "Word template"
      case .email: return "Email"
      case .eps: return "EPS"
      case .epub: return "EPUB"
      case .erlang: return "Erlang"
      case .fla: return "Flash FLA"
      case .flv: return "Flash video"
      case .fsharp: return "F#"
      case .fortran: return "Fortran"
      case .gdoc: return "GDocs Document"
      case .gdraw: return "GDocs Drawing"
      case .gif: return "GIF"
      case .go: return "Go"
      case .gpres: return "GDocs Presentation"
      case .groovy: return "Groovy"
      case .gsheet: return "GDocs Spreadsheet"
      case .gzip: return "Gzip"
      case .html: return "HTML"
      case .handlebars: return "Handlebars"
      case .haskell: return "Haskell"
      case .haxe: return "Haxe"
      case .indd: return "InDesign Document"
      case .java: return "Java"
      case .javascript: return "JavaScript"
      case .jpg: return "JPEG"
      case .json: return "JSON"
      case .keynote: return "Keynote Document"
      case .kotlin: return "Kotlin"
      case .latex: return "LaTeX/sTeX"
      case .lisp: return "Lisp"
      case .lua: return "Lua"
      case .m4a: return "MPEG 4 audio"
      case .markdown: return "Markdown (raw)"
      case .matlab: return "MATLAB"
      case .mhtml: return "MHTML"
      case .mkv: return "Matroska video"
      case .mov: return "QuickTime video"
      case .mp3: return "mp4"
      case .mp4: return "MPEG 4 video"
      case .mpg: return "MPEG video"
      case .mumps: return "MUMPS"
      case .numbers: return "Numbers Document"
      case .nzb: return "NZB"
      case .objc: return "Objective-C"
      case .ocaml: return "OCaml"
      case .odg: return "OpenDocument Drawing"
      case .odi: return "OpenDocument Image"
      case .odp: return "OpenDocument Presentation"
      case .ods: return "OpenDocument Spreadsheet"
      case .odt: return "OpenDocument Text"
      case .ogg: return "Ogg Vorbis"
      case .ogv: return "Ogg video"
      case .pages: return "Pages Document"
      case .pascal: return "Pascal"
      case .pdf: return "PDF"
      case .perl: return "Perl"
      case .php: return "PHP"
      case .pig: return "Pig"
      case .png: return "PNG"
      case .post: return "Slack Post"
      case .powershell: return "PowerShell"
      case .ppt: return "PowerPoint presentation"
      case .pptx: return "PowerPoint presentation"
      case .psd: return "Photoshop Document"
      case .puppet: return "Puppet"
      case .python: return "Python"
      case .qtz: return "Quartz Composer Composition"
      case .r: return "R"
      case .rtf: return "Rich Text File"
      case .ruby: return "Ruby"
      case .rust: return "Rust"
      case .sql: return "SQL"
      case .sass: return "Sass"
      case .scala: return "Scala"
      case .scheme: return "Scheme"
      case .sketch: return "Sketch File"
      case .shell: return "Shell"
      case .smalltalk: return "Smalltalk"
      case .svg: return "SVG"
      case .swf: return "Flash SWF"
      case .swift: return "Swift"
      case .tar: return "Tarball"
      case .tiff: return "TIFF"
      case .tsv: return "TSV"
      case .vb: return "VB.NET"
      case .vbscript: return "VBScript"
      case .vcard: return "vCard"
      case .velocity: return "Velocity"
      case .verilog: return "Verilog"
      case .wav: return "Waveform audio"
      case .webm: return "WebM"
      case .wmv: return "Windows Media Video"
      case .xls: return "Excel spreadsheet"
      case .xlsx: return "Excel spreadsheet"
      case .xlsb: return "Excel Spreadsheet (Binary, Macro Enabled)"
      case .xlsm: return "Excel Spreadsheet (Macro Enabled)"
      case .xltx: return "Excel template"
      case .xml: return "XML"
      case .yaml: return "YAML"
      case .zip: return "Zip"
      }
    }
  }
}
