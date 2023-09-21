import BlockKitBuilder
import SlackPrimaryTypes
import Vapor

public struct ResponedView: Codable {
  public let id: String
  public let type: String
  public let private_metadata: String
  public let callback_id: String
  public let state: State
  public let hash: String
  public let previous_view_id: String?
  public let root_view_id: String?
  public let app_id: String
  public let external_id: String
  public let app_installed_team_id: TeamID
  public let bot_id: String
}

extension ResponedView {
  public struct State: Codable {
    public var values: [String: [String: Value]]
  }
}

extension ResponedView.State {
  public enum Value: Codable {
    case plainTextInput(String?)
    case urlTextInput(URI?)
    case staticSelect(BlockKitBuilder.Option?)
    case button(value: String?, text: Text?)
    case multiUsersSelect([UserID])
  }
}

extension ResponedView.State.Value {
    
  enum CodingKeys: String, CodingKey {
    case type
    case value
    case selectedOption = "selected_option"
    case text
    case selectedUsers = "selected_users"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)
    
    switch type {
    case "plain_text_input":
      let value = try container.decode(String?.self, forKey: .value)
      self = .plainTextInput(value)
    case "url_text_input":
      let value = try container.decode(URI?.self, forKey: .value)
      self = .urlTextInput(value)
    case "static_select":
      let value = try container.decodeIfPresent(Option.self, forKey: .selectedOption)
      self = .staticSelect(value)
    case "button":
      let text = try container.decode(Text?.self, forKey: .text)
      let value = try container.decodeIfPresent(String.self, forKey: .value)
      self = .button(value: value, text: text)
    case "multi_users_select":
      let users = try container.decode([UserID].self, forKey: .selectedUsers)
      self = .multiUsersSelect(users)
    default:
      throw DecodingError.dataCorruptedError(
        forKey: CodingKeys.type, in: container,
        debugDescription: "'\(type)' is unknown type")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .plainTextInput(let value):
      try container.encode("plainTextInput", forKey: .type)
      try container.encode(value, forKey: .value)
    case .urlTextInput(let value):
      try container.encode("urlTextInput", forKey: .type)
      try container.encode(value, forKey: .value)
    case .staticSelect(let value):
      try container.encode("staticSelect", forKey: .type)
      try container.encodeIfPresent(value, forKey: .selectedOption)
    case .button(let value, let text):
      try container.encode("button", forKey: .type)
      try container.encodeIfPresent(value, forKey: .value)
      try container.encode(text, forKey: .text)
    case .multiUsersSelect(let users):
      try container.encode("multi_users_select", forKey: .type)
      try container.encode(users, forKey: .selectedUsers)
    }
  }
  
  public var type: String {
    switch self {
    case .plainTextInput:   return "plain_text_input"
    case .urlTextInput:     return "url_text_input"
    case .staticSelect:     return "static_select"
    case .button:           return "button"
    case .multiUsersSelect: return "multi_users_select"
    }
  }
}
