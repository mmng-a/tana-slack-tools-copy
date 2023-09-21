@resultBuilder
public struct BlocksBuilder: ArrayBuilderProtocol {
  public typealias Component = any Block
  public typealias ResultElement = AnyBlock
  
  public static func buildFinalResult(_ component: [any Block]) -> [AnyBlock] {
    component.map(AnyBlock.init)
  }
  
  public static func buildExpression(_ expression: Void) -> [Self.ResultElement] {
    []
  }
}
