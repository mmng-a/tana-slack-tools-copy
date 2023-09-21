public protocol ActionsElementable: Element {}
extension Button: ActionsElementable {}
extension StaticSelectMenu: ActionsElementable {}
extension OverflowMenu: ActionsElementable {}
//extension DatePicker: ActionsElementable {}

extension AttributedElement: ActionsElementable where BaseElement: ActionsElementable {}
extension AnyElement: ActionsElementable {}


@resultBuilder
public struct ActionsElementsBuilder: ArrayBuilderProtocol {
  public typealias Component = any ActionsElementable
  public typealias ResultElement = any ActionsElementable
}
