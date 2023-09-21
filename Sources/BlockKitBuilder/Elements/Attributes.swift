// MARK: - dispatch_action_config
public protocol Dispatchable: Element {}

extension Dispatchable {
  public func dispatch(_ config: DispatchActionConfig) -> AttributedElement<Self> {
    AttributedElement(base: self).dispatch(config)
  }
}

extension AttributedElement: Dispatchable where BaseElement: Dispatchable {
  public func dispatch(_ config: DispatchActionConfig) -> AttributedElement<BaseElement> {
    self.modify(\._attributes, { $0["dispatch_action_config"] = config })
  }
}

// MARK: - focus_on_load
public protocol FocusableOnLoad: Element {}

extension FocusableOnLoad {
  public func focusOnLoad(_ isOn: Bool = true) -> AttributedElement<Self> {
    AttributedElement(base: self).focusOnLoad(isOn)
  }
}

extension AttributedElement: FocusableOnLoad where BaseElement: FocusableOnLoad {
  public func focusOnLoad(_ isOn: Bool = true) -> AttributedElement<BaseElement> {
    self.modify(\._attributes, { $0["focus_on_load"] = isOn })
  }
}

// MARK: - placeholder
public protocol PlaceholderShowable: Element {}

extension PlaceholderShowable {
  public func placeholder(_ text: PlainText) -> AttributedElement<Self> {
    AttributedElement(base: self).placeholder(text)
  }
}

extension AttributedElement: PlaceholderShowable where BaseElement: PlaceholderShowable {
  public func placeholder(_ text: PlainText) -> AttributedElement<BaseElement> {
    self.modify(\._attributes, { $0["placeholder"] = text })
  }
}

// MARK: - confirm
public protocol ConfirmarionShowable: Element {}

extension ConfirmarionShowable {
  public func showConfirmation(_ confirmation: Confirmation) -> AttributedElement<Self> {
    AttributedElement(base: self).showConfirmation(confirmation)
  }
}

extension AttributedElement: ConfirmarionShowable where BaseElement: ConfirmarionShowable {
  public func showConfirmation(_ confirmation: Confirmation) -> AttributedElement<BaseElement> {
    self.modify(\._attributes, { $0["confirm"] = confirmation })
  }
}
