import Fluent

struct CreateFlowMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("flow")
      .id()
      .field("title", .string, .required)
      .field("url", .string, .required)
      .field("state", .int, .required)
      .field("applicant-user-id", .string, .required)
      .field("co-authores", .array(of: .string), .required)
      .field("section-name", .string, .required)
      .field("thread-ts", .string)
      .field("recent-thread-message-ts", .string)
      .field("created-at", .datetime)
      .field("updated-at", .datetime)
      .field("number", .int)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("flow").delete()
  }
}
