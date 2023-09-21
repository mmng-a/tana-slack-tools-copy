public protocol Modifiable {}

extension Modifiable {
  public func modify<T>(_ path: WritableKeyPath<Self, T>, with newValue: T) -> Self {
    var copy = self
    copy[keyPath: path] = newValue
    return copy
  }
  
  public func modify<T>(_ path: WritableKeyPath<Self, T>, _ transform: (inout T) -> Void) -> Self {
    var copy = self
    transform(&copy[keyPath: path])
    return copy
  }
  
  public func modifyIf<T>(_ condition: Bool, _ path: WritableKeyPath<Self, T>, with newValue: T) -> Self {
    condition ? self.modify(path, with: newValue) : self
  }
  
  public func modifyIf<T>(_ condition: Bool, _ path: WritableKeyPath<Self, T>, _ transform: (inout T) -> Void) -> Self {
    condition ? self.modify(path, transform) : self
  }
}

