enum State: Int, Codable, Equatable {
  // 投稿キャンセル
  case cancelled = 0
  
  case revisioning1 = 5
  // 局長チェック
  case chiefChecking = 10
  case revisioning2 = 15
  // 執行部隊チェック
  case exectionUnitChecking = 20
  // 副代表チェック
  case subrepresentativeChecking = 30
  case writingNumber = 35
  // SLチェック
  case submitted = 40
}

extension State {
  @available(*, unavailable, renamed: "exectionUnitChecking")
  var chiefChecked: State { .exectionUnitChecking }
  
  @available(*, unavailable, renamed: "subrepresentativeChecking")
  var exectionUnitChecked: State { .subrepresentativeChecking }

  @available(*, unavailable, renamed: "submitted")
  var subrepresentativeChecked: State { .submitted }
}

extension State {
  
  enum Action: Codable, Equatable {
    case next
    case revert
    case skipTo(State)
  }
  
  mutating func doAction(_ action: Action) {
    self = newState(after: action)
  }
  
  func newState(after action: Action) -> State {
    switch action {
    case .next:
      return nextState()
    case .revert:
      return revertState()
    case .skipTo(let state):
      return state
    }
  }
  
  func nextState() -> State {
    switch self {
    case .cancelled:                 return .chiefChecking
    case .revisioning1:              return .chiefChecking
    case .chiefChecking:             return .exectionUnitChecking
    case .revisioning2:              return .exectionUnitChecking
    case .exectionUnitChecking:      return .subrepresentativeChecking
    case .subrepresentativeChecking: return .writingNumber
    case .writingNumber:             return .submitted
    case .submitted:                 return .submitted
    }
  }
  
  func revertState() -> State {
    switch self {
    case .cancelled:                 return .cancelled
    case .revisioning1:              return .cancelled
    case .chiefChecking:             return .revisioning1
    case .revisioning2:              return .cancelled
    case .exectionUnitChecking:      return .revisioning2
    case .subrepresentativeChecking: return .revisioning2
    case .writingNumber:             return .subrepresentativeChecking
    case .submitted:                 return .writingNumber
    }
  }
}

extension State: CustomStringConvertible {
  var description: String {
    switch self {
    case .cancelled:                 return "キャンセル済み"
    case .revisioning1:              return "修正中"
    case .chiefChecking:             return "局長チェック"
    case .revisioning2:              return "修正中"
    case .exectionUnitChecking:      return "執行部隊チェック"
    case .subrepresentativeChecking: return "副代表チェック"
    case .writingNumber:             return "申請書ナンバー記入"
    case .submitted:                 return "提出済み"
    }
  }
}

extension State: CaseIterable {}
