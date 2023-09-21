public protocol ArrayBuilderProtocol {
  associatedtype Component
  associatedtype ResultElement
  
  static func buildFinalResult(_ component: [Component]) -> [ResultElement]
}

extension ArrayBuilderProtocol {
  public static func buildExpression(_ expression: Component) -> [Component] {
    [expression]
  }
  
  public static func buildExpression(_ expression: [Component]) -> [Component] {
    expression
  }
  
  public static func buildBlock(_ components: [Component]...) -> [Component] {
    components.flatMap { $0 }
  }
  
  public static func buildOptional(_ component: [Component]?) -> [Component] {
    component ?? []
  }
  
  public static func buildEither(first component: [Component]) -> [Component] {
    component
  }
  
  public static func buildEither(second component: [Component]) -> [Component] {
    component
  }
  
  public static func buildArray(_ components: [[Component]]) -> [Component] {
    components.flatMap { $0 }
  }
}

extension ArrayBuilderProtocol where Component == ResultElement {
  public static func buildFinalResult(_ component: [Component]) -> [ResultElement] {
    component
  }
}
