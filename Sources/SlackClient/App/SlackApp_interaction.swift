import Vapor

extension SlackApp {
  internal func onInteraction(_ req: Request) async throws -> Response  {
    let payloadData = try req.content.get(String.self, at: "payload").data(using: .utf8)!
    let decoder = JSONDecoder()
    let interactionPayload = try decoder.decode(InteractionPayload.self, from: payloadData)
    
    let res: Response
    switch interactionPayload {
    case .blockActions(let blockAction):
      guard let action = blockAction.actions.first else {
        throw Abort(.badRequest)
      }
      guard let fn = interactionCallbacks.onBlockActions[match: action.blockID, action.actionID] else {
        req.logger.log(level: .warning, "unknown block action (block_id: \(action.blockID), action_id: \(action.actionID)")
        throw Abort(.notImplemented)
      }
      res = try await fn(req, blockAction)
      
    case .viewSubmission(let viewSubmission):
      let callbackID = viewSubmission.view.callback_id
      guard let fn = interactionCallbacks.onViewSubmissions[callbackID] else {
        req.logger.log(level: .warning, "unknown view submission '\(callbackID)'")
        throw Abort(.notImplemented)
      }
      res = try await fn(req, viewSubmission)
      
    case .viewClosed:
      throw Abort(.notImplemented)
      
    case .shortcut(let shortcut):
      guard let fn = interactionCallbacks.onShortcuts[shortcut.callbackID] else {
        req.logger.log(level: .warning, "unknown shortcut '\(shortcut.callbackID)'")
        throw Abort(.notImplemented)
      }
      res = try await fn(req, shortcut)
      
    case .messageAction:
      throw Abort(.notImplemented)
      
    case .workflowStepEdit(let workflowStepEdit):
      guard let fn = interactionCallbacks.onWorkflowStepEdits[workflowStepEdit.callbackID] else {
        req.logger.log(level: .warning, "unknown workflow step edit '\(workflowStepEdit.callbackID)'")
        throw Abort(.notImplemented)
      }
      res = try await fn(req, workflowStepEdit)
    }
    return res
  }
}

extension SlackApp {
  public typealias OnShortcut = ((_ req: Request, _ shortcut: InteractionPayload.Shortcut) async throws -> Response)
  public typealias OnViewSubmission = ((_ req: Request, _ viewSubmission: InteractionPayload.ViewSubmission) async throws -> Response)
  public typealias OnWorkflowStepEdit = ((_ req: Request, _ workflowStepEdit: InteractionPayload.WorkflowStepEdit) async throws -> Response)
  public typealias OnBlockAction = ((_ req: Request, _ blockAction: InteractionPayload.BlockAction) async throws -> Response)
  
  internal struct BlockActionConstraints: Hashable {
    var blockID: String?
    var actionID: String?
    
    func match(blockID: String, actionID: String) -> Bool {
      switch (self.blockID, self.actionID) {
      case (.some(let _blockID), .some(let _actionID)):
        return _blockID == blockID && _actionID == actionID
      case (.some(let _blockID), .none):
        return _blockID == blockID
      case (.none, .some(let _actionID)):
        return _actionID == actionID
      case (.none, .none):
        return true
      }
    }
  }
}

internal extension Dictionary where Key == SlackApp.BlockActionConstraints, Value == SlackApp.OnBlockAction {
  subscript(match blockID: String, actionID: String) -> Value? {
    return self.first(where: { (key, _) in
      key.match(blockID: blockID, actionID: actionID)
    })?.value
  }
}

extension SlackApp {
  internal struct InteractionCallbacks {
    var onShortcuts: [String: OnShortcut] = [:]
    var onViewSubmissions: [String: OnViewSubmission] = [:]
    var onWorkflowStepEdits: [String: OnWorkflowStepEdit] = [:]
    var onBlockActions: [BlockActionConstraints: OnBlockAction] = [:]
  }
  
  @_disfavoredOverload
  public func onShortcut(_ callbackID: String, use function: @escaping OnShortcut) {
    interactionCallbacks.onShortcuts[callbackID] = function
  }
  
  public func onShortcut(
    _ callbackID: String,
    use function: @escaping (_ req: Request, _ shortcut: InteractionPayload.Shortcut) async throws -> Void
  ) {
    onShortcut(callbackID) { req, shortcut in
      try await function(req, shortcut)
      return Response(status: .ok)
    }
  }
  
  @_disfavoredOverload
  public func onViewSubmission(_ callbackID: String, use function: @escaping OnViewSubmission) {
    interactionCallbacks.onViewSubmissions[callbackID] = function
  }
  
  public func onViewSubmission(
    _ callbackID: String,
    use function: @escaping (_ req: Request, _ viewSubmission: InteractionPayload.ViewSubmission) async throws -> Void
  ) {
    onViewSubmission(callbackID) { req, viewSubmission in
      try await function(req, viewSubmission)
      return Response(status: .ok)
    }
  }
  
  @_disfavoredOverload
  public func onWorkflowStepEdit(_ callbackID: String, use function: @escaping OnWorkflowStepEdit) {
    interactionCallbacks.onWorkflowStepEdits[callbackID] = function
  }
  
  public func onWorkflowStepEdit(
    _ callbackID: String,
    use function: @escaping (_ req: Request, _ workflowStepEdit: InteractionPayload.WorkflowStepEdit) async throws -> Void
  ) {
    onWorkflowStepEdit(callbackID) { req, workflowStepEdit in
      try await function(req, workflowStepEdit)
      return Response(status: .ok)
    }
  }
  
  @_disfavoredOverload
  public func onBlockAction(blockID: String?, actionID: String?, use function: @escaping OnBlockAction) {
    let constraints = BlockActionConstraints(blockID: blockID, actionID: actionID)
    interactionCallbacks.onBlockActions[constraints] = function
  }
  
  public func onBlockAction(
    blockID: String?, actionID: String?,
    use function: @escaping (_ req: Request, _ blockAction: InteractionPayload.BlockAction) async throws -> Void
  ) {
    onBlockAction(blockID: blockID, actionID: actionID) { req, blockAction in
      try await function(req, blockAction)
      return Response(status: .ok)
    }
  }
}
