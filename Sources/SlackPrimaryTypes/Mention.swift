public protocol Mention: CustomStringConvertible {}

public enum SpecialMention: String, Mention {
  case everyone
  case channel
  case here
  
  public var description: String {
    "<!\(rawValue)>"
  }
}
