public enum VoiceInputSessionState: Equatable, Sendable {
    case idle
    case permissionBlocked([VoiceInputPermission])
    case pendingRecording
    case recording
    case transcribing
    case failed(String)
}

public enum VoiceInputPermission: Equatable, Sendable {
    case microphone
    case accessibility
}

public struct VoiceInputPermissions: Equatable, Sendable {
    public var microphoneGranted: Bool
    public var accessibilityGranted: Bool

    public static let allGranted = VoiceInputPermissions(
        microphoneGranted: true,
        accessibilityGranted: true
    )

    public static let missingMicrophone = VoiceInputPermissions(
        microphoneGranted: false,
        accessibilityGranted: true
    )
}

public final class VoiceInputSession {
    public private(set) var state: VoiceInputSessionState
    private let permissions: VoiceInputPermissions

    public init(permissions: VoiceInputPermissions = .allGranted) {
        self.permissions = permissions
        self.state = .idle
    }

    public func requestRecording() {
        if !permissions.microphoneGranted {
            state = .permissionBlocked([.microphone])
        } else {
            state = .pendingRecording
        }
    }

    public func beginRecording() {
        if state == .pendingRecording {
            state = .recording
        }
    }

    public func finishRecording() {
        if state == .recording {
            state = .transcribing
        }
    }

    public func fail(_ message: String) {
        state = .failed(message)
    }

    public func reset() {
        state = .idle
    }
}
