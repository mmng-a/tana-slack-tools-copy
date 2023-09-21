import Vapor
import SlackClient

struct UserGroup: Content {
  var id: UserGroupID?
  var userIDs: [UserID]
}

extension UserGroup {
  static var executive = UserGroup(id: .executive, userIDs: [
    .user1, .user2, .user3, .user4, .user5
  ])
  
  static var teamExecution = UserGroup(id: .teamExecution, userIDs: [
    .user6, .masashi_aso, .user9
  ])
}

extension UserGroupID {
  
  static let executive = UserGroupID("S044XXXXXXX")
  static let teamExecution = UserGroupID("S044XXXXXXX")
  
}
