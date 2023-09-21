public protocol ContextBlockElementable: Element {}
//extension ImageElement: ContextBlockElementable {}
extension Text: ContextBlockElementable {}
extension PlainText: ContextBlockElementable {}
extension Markdown: ContextBlockElementable {}

extension AttributedElement: ContextBlockElementable where BaseElement: ContextBlockElementable {}
extension AnyElement: ContextBlockElementable {}


@resultBuilder
public struct ContextBlockElementsBuilder: ArrayBuilderProtocol {
  public typealias Component = any ContextBlockElementable
  public typealias ResultElement = any ContextBlockElementable
}
