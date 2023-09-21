import Vapor

public struct SlackClient {
  let appClient: any Vapor.Client
  let authedHeaders: HTTPHeaders
  
  public init(_ appClient: any Vapor.Client, slackBotToken: String) {
    self.appClient = appClient
    var headers = HTTPHeaders()
    headers.bearerAuthorization = .init(token: slackBotToken)
    self.authedHeaders = headers
  }
}

extension SlackClient {
  func uri(for api: String) -> URI {
    URI("https://slack.com/api/\(api)")
  }
}
