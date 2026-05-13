import XCTest
@testable import VoiceInputCore

final class VoiceInputSessionTests: XCTestCase {
    func testNewSessionStartsIdle() {
        let session = VoiceInputSession()

        XCTAssertEqual(session.state, .idle)
    }

    func testMissingPermissionsBlocksRecording() {
        let session = VoiceInputSession(permissions: .missingMicrophone)

        session.requestRecording()

        XCTAssertEqual(session.state, .permissionBlocked([.microphone]))
    }

    func testRequestRecordingMovesIdleSessionToPendingRecording() {
        let session = VoiceInputSession(permissions: .allGranted)

        session.requestRecording()

        XCTAssertEqual(session.state, .pendingRecording)
    }

    func testPendingRecordingCanBeginRecording() {
        let session = VoiceInputSession(permissions: .allGranted)

        session.requestRecording()
        session.beginRecording()

        XCTAssertEqual(session.state, .recording)
    }

    func testRecordingCanFinishAndStartTranscribing() {
        let session = VoiceInputSession(permissions: .allGranted)

        session.requestRecording()
        session.beginRecording()
        session.finishRecording()

        XCTAssertEqual(session.state, .transcribing)
    }

    func testFailureCanResetToIdle() {
        let session = VoiceInputSession(permissions: .allGranted)

        session.fail("transcription timed out")
        XCTAssertEqual(session.state, .failed("transcription timed out"))

        session.reset()
        XCTAssertEqual(session.state, .idle)
    }

    func testClosingSettingsDoesNotRequestAppTermination() {
        let controller = MenuBarAppController()

        controller.openSettings()
        controller.closeSettings()

        XCTAssertFalse(controller.isSettingsVisible)
        XCTAssertFalse(controller.isTerminationRequested)
    }

    func testQuitRequestsAppTermination() {
        let controller = MenuBarAppController()

        controller.quit()

        XCTAssertTrue(controller.isTerminationRequested)
    }

    func testMenuBarControllerExposesSettingsAndQuitCommands() {
        let controller = MenuBarAppController()

        XCTAssertEqual(controller.availableCommands, [.openSettings, .quit])
    }
}
