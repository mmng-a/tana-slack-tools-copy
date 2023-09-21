import Vapor

internal enum SlackResult<Success>: Decodable where Success: Decodable {
  case ok(Success, metadata: ResponseMetadata?)
  case fail(SlackError, metadata: ResponseMetadata?)
  
  enum CodingKeys: CodingKey {
    case ok
    case error
    case response_metadata
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let ok = try container.decode(Bool.self, forKey: .ok)
    let metadata = try container.decodeIfPresent(ResponseMetadata.self, forKey: .response_metadata)
    if ok {
      self = .ok(try Success(from: decoder), metadata: metadata)
    } else {
      self = .fail(try SlackError(from: decoder), metadata: metadata)
    }
  }
  
  func get() throws -> Success {
    switch self {
    case .ok(let success, _): return success
    case .fail(let failure, _): throw failure
    }
  }
}

public struct ResponseMetadata: Decodable {
  public var warnings: [String]?
  public var nextCursor: String?
  
  public var scopes: [String]?
  public var acceptedScopes: [String]?
  public var retryAfter: Int?
  public var messages: [String]?
  
  enum CodingKeys: String, CodingKey {
    case warnings
    case nextCursor = "next_cursor"
    case scopes
    case acceptedScopes = "accepted_scopes"
    case retryAfter = "retry_after"
    case messages
  }
}
