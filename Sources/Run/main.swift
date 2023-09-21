import ApplicationFlow
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try ApplicationFlow.configure(app)
app.routes.defaultMaxBodySize = "1mb"
try app.run()
