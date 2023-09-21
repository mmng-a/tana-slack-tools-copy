import Vapor
import SlackClient

extension Environment {
  static var SLACK_BOT_TOKEN: String {
    Environment.get("APPLICATION_FLOW_SLACK_BOT_TOKEN")!
  }
  
  static var MANAGEMENT_FLOW_CHANNEL: String {
    Environment.get("MANAGEMENT_FLOW_CHANNEL")!
  }
}

extension BearerAuthorization {
  static var slackBotAutorization: BearerAuthorization {
    BearerAuthorization(token: Environment.SLACK_BOT_TOKEN)
  }
}

extension ChannelID {
  static var managementFlows: ChannelID {
    ChannelID(Environment.MANAGEMENT_FLOW_CHANNEL)
  }
}
