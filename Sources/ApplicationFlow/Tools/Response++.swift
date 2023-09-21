import Foundation
import Vapor

extension Response {
  static func json(
    _ codable: some Codable,
    status: HTTPResponseStatus = .ok,
    version: HTTPVersion = .http1_1,
    headers: HTTPHeaders = .init()
  ) throws -> Self {
    let jsonEncoder = JSONEncoder()
    let encoded = try jsonEncoder.encode(codable)
    var headers = headers
    headers.contentType = .json
    return self.init(status: status, version: version, headers: headers, body: .init(data: encoded))
  }
}
