import Fluent
import SlackClient

struct CreateUserMigration: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("users")
      .field(.id, .string, .identifier(auto: false))
      .field("recent-sections", .array(of: .string), .required)
      .field("home-tab-state_category", .string)
      .field("home-tab-state_sections", .array(of: .string))
      .field("home-tab-state_show-all-sections", .bool)
      .field("home-tab-state_page", .int)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("users").delete()
  }
}
