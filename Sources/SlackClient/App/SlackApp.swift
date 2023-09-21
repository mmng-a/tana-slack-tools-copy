import Vapor

public class SlackApp {
  var interactionCallbacks = InteractionCallbacks()
  
  public init(_ routeBuilder: some RoutesBuilder) {
    routeBuilder.post("interactive", use: onInteraction(_:))
    
  }
}

