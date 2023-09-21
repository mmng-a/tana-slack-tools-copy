@resultBuilder
public struct ElementsBuilder: ArrayBuilderProtocol {
  public typealias Component = any Element
  public typealias ResultElement = AnyElement
  
  public static func buildFinalResult(_ component: [any Element]) -> [AnyElement] {
    component.map(AnyElement.init)
  }
  
  public static func buildExpression(_ expression: Void) -> [Self.Component] {
    []
  }
}
