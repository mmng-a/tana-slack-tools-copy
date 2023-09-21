import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

// configures your application
public func configure(_ app: Application) throws {
  // uncomment to serve files from /Public folder
  // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
  app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
  
  app.migrations.add(CreateUserMigration())
  app.migrations.add(CreateFlowMigration())
  
  // register routes
  try routes(app.grouped("application-flow"))
}
