public enum MenuBarCommand: Equatable, Sendable {
    case openSettings
    case quit
}

public final class MenuBarAppController {
    public let availableCommands: [MenuBarCommand]
    public private(set) var isSettingsVisible: Bool
    public private(set) var isTerminationRequested: Bool

    public init() {
        self.availableCommands = [.openSettings, .quit]
        self.isSettingsVisible = false
        self.isTerminationRequested = false
    }

    public func openSettings() {
        isSettingsVisible = true
    }

    public func closeSettings() {
        isSettingsVisible = false
    }

    public func quit() {
        isTerminationRequested = true
    }
}
