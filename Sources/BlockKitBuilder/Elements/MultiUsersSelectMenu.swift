import struct SlackPrimaryTypes.UserID

public struct MultiUsersSelectMenu: Element {
  fileprivate(set) public var type: String = "multi_users_select"
  public var actionID: String
  public var initialUsers: [UserID]?
  public var maxSelectedItems: Int?
  
  enum CodingKeys: String, CodingKey {
    case type = "type"
    case actionID = "action_id"
    case initialUsers = "initial_users"
    case maxSelectedItems = "max_selected_items"
  }
  
  public init(actionID: String, initialUsers: [UserID]? = nil, maxSelectedItems: Int? = nil) {
    self.actionID = actionID
    self.initialUsers = initialUsers
    self.maxSelectedItems = maxSelectedItems
  }
}

extension MultiUsersSelectMenu: ConfirmarionShowable {}
extension MultiUsersSelectMenu: FocusableOnLoad {}
extension MultiUsersSelectMenu: PlaceholderShowable {}
