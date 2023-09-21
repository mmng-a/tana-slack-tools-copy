import BlockKitBuilder
import SlackPrimaryTypes
import Vapor

extension InteractionPayload.BlockAction {
  public enum Action: Decodable {
    case button(ButtonAction)
//    case usersSelect
//    case multiUsersSelect
    case staticSelect(StaticSelectAction)
//    case conversationSelect
//    case multiConversationSelect
//    case channelSelect
//    case multiChannelSelect
    case overflow(OverflowAction)
//    case datepicker
//    case radioButton
//    case checkboxes
//    case plainTextInput
  }
}

fileprivate protocol ActionProtocol {
  var type: String { get }
  var blockID: String { get }
  var actionID: String { get }
  var actionTS: String { get }
}

extension InteractionPayload.BlockAction.Action: ActionProtocol {
  fileprivate func getAnyAction() -> any ActionProtocol {
    switch self {
    case .overflow(let value): return value
    case .button(let value): return value
    case .staticSelect(let value): return value
    }
  }
  
  public var type: String { getAnyAction().type }
  public var blockID: String { getAnyAction().blockID }
  public var actionID: String { getAnyAction().actionID }
  public var actionTS: String { getAnyAction().actionTS }
}

extension InteractionPayload.BlockAction.Action {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BasicCodingKey.self)
    let type = try container.decode(String.self, forKey: .key("type"))
    switch type {
    case "overflow": self = .overflow(try OverflowAction(from: decoder))
    case "button": self = .button(try ButtonAction(from: decoder))
    case "static_select": self = .staticSelect(try StaticSelectAction(from: decoder))
    default:
      throw DecodingError.dataCorruptedError(forKey: BasicCodingKey.key("type"), in: container, debugDescription: "unknown type '\(type)'")
    }
  }
}

// MARK: - ActionTypes
extension InteractionPayload.BlockAction.Action {
  public struct OverflowAction: Codable, ActionProtocol {
    public let type: String // overflow
    public let actionID: String
    public let blockID: String
    public let actionTS: String
    public let selectedOption: BlockKitBuilder.Option
    
    enum CodingKeys: String, CodingKey {
      case type
      case actionID = "action_id"
      case blockID = "block_id"
      case actionTS = "action_ts"
      case selectedOption = "selected_option"
    }
  }
  
  public struct ButtonAction: Codable, ActionProtocol {
    public let type: String // button
    public let actionID: String
    public let blockID: String
    public let actionTS: String
    public let text: Text
    public let style: BlockKitBuilder.Button.Style?
    public let value: String?
    
    enum CodingKeys: String, CodingKey {
      case type
      case actionID = "action_id"
      case blockID = "block_id"
      case actionTS = "action_ts"
      case text
      case style
      case value
    }
  }
  
  public struct StaticSelectAction: Codable, ActionProtocol {
    public let type: String // static_select
    public let actionID: String
    public let blockID: String
    public let actionTS: String
    public let selectedOption: BlockKitBuilder.Option
    public let initialOption: BlockKitBuilder.Option?
    
    enum CodingKeys: String, CodingKey {
      case type
      case actionID = "action_id"
      case blockID = "block_id"
      case actionTS = "action_ts"
      case selectedOption = "selected_option"
      case initialOption = "initial_option"
    }
  }
}
