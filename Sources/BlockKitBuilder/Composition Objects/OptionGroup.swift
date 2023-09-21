public struct OptionGroup: Codable {
  var label: PlainText
  var options: [Option]
  
  public init(_ label: PlainText, @OptionsBuilder options: () -> [Option]) {
    self.label = label
    self.options = options()
  }
  
  public init<T>(
    _ label: PlainText,
    data: some Sequence<T>,
    transform: (T) -> Option
  ) {
    self.label = label
    self.options = data.map(transform)
  }
}
