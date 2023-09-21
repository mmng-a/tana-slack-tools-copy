import Vapor

extension SlackClient {
  public func response(to responseURI: URI, body: some Content) async throws -> ClientResponse {
    try await appClient.post(responseURI, content: body)
  }
}
