public protocol InputElementable: Element {}
extension PlainTextInput: InputElementable {}
//extension CheckBox: InputElementable {}
//extension RadioButton: InputElementable {}
extension StaticSelectMenu: InputElementable {}
extension MultiStaticSelectMenu: InputElementable {}
extension MultiUsersSelectMenu: InputElementable {}
extension URLTextInput: InputElementable {}

extension AttributedElement: InputElementable where BaseElement: InputElementable {}
extension AnyElement: InputElementable {}
