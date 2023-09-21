import Foundation
import Fluent
import Vapor
import SlackClient

final class ApplicationFlow: Model, Content {
  static let schema = "flow"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "title")
  var title: String
  
  @Field(key: "url")
  var url: URL
  
  @Field(key: "state")
  var state: State
  
  @Field(key: "thread-ts")
  var threadTS: String!
  
  @Field(key: "recent-thread-message-ts")
  var recentThreadMessageTS: String!
  
  @Field(key: "applicant-user-id")
  var applicantUserID: UserID
  
  @Field(key: "co-authores")
  var coAuthores: [UserID]
  
  @Field(key: "section-name")
  var sectionName: TanaSectionName
  
  @Timestamp(key: "created-at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated-at", on: .update)
  var updatedAt: Date?
  
  @Field(key: "number")
  var number: Int?
  
  init() {}
  
  init(
    title: String,
    url: URL,
    state: State,
    threadTS: String?,
    applicantUserID: UserID,
    coAuthores: [UserID] = [],
    sectionName: TanaSectionName
  ) {
    self.title = title
    self.url = url
    self.state = state
    self.threadTS = threadTS
    self.applicantUserID = applicantUserID
    self.coAuthores = coAuthores
    self.sectionName = sectionName
    self.number = nil
  }
}

extension ApplicationFlow {
  var section: TanaSection { TanaSection(sectionName) }
  
  var checkingUserIDs: [UserID] {
    switch state {
    case .revisioning1, .revisioning2, .cancelled:
      return []
    case .chiefChecking:
      return Array([section.chief, section.boss].compacted())
    case .exectionUnitChecking:
      return UserGroup.teamExecution.userIDs
    case .subrepresentativeChecking:
      return [UserID.user2]
    case .writingNumber:
      return [UserID.user2]
    case .submitted:
      return []
    }
  }
}
