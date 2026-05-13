import VoiceInputCore

func expectEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String) {
    if actual != expected {
        fatalError("\(message): expected \(expected), got \(actual)")
    }
}

func testNewSessionStartsIdle() {
    let session = VoiceInputSession()
    expectEqual(session.state, .idle, "New sessions should start idle")
}

func testMissingPermissionsBlocksRecording() {
    let session = VoiceInputSession(permissions: .missingMicrophone)

    session.requestRecording()

    expectEqual(session.state, .permissionBlocked([.microphone]), "Missing permissions should block recording")
}

func testRequestRecordingMovesIdleSessionToPendingRecording() {
    let session = VoiceInputSession(permissions: .allGranted)

    session.requestRecording()

    expectEqual(session.state, .pendingRecording, "Allowed recording requests should become pending")
}

func testPendingRecordingCanBeginRecording() {
    let session = VoiceInputSession(permissions: .allGranted)

    session.requestRecording()
    session.beginRecording()

    expectEqual(session.state, .recording, "Pending recording sessions should begin recording")
}

func testRecordingCanFinishAndStartTranscribing() {
    let session = VoiceInputSession(permissions: .allGranted)

    session.requestRecording()
    session.beginRecording()
    session.finishRecording()

    expectEqual(session.state, .transcribing, "Finished recordings should start transcribing")
}

func testFailureCanResetToIdle() {
    let session = VoiceInputSession(permissions: .allGranted)

    session.fail("transcription timed out")
    expectEqual(session.state, .failed("transcription timed out"), "Failures should be visible in session state")

    session.reset()
    expectEqual(session.state, .idle, "Reset should return failed sessions to idle")
}

func testClosingSettingsDoesNotRequestAppTermination() {
    let controller = MenuBarAppController()

    controller.openSettings()
    controller.closeSettings()

    expectEqual(controller.isSettingsVisible, false, "Closing settings should hide settings")
    expectEqual(controller.isTerminationRequested, false, "Closing settings should keep the menu bar app running")
}

func testQuitRequestsAppTermination() {
    let controller = MenuBarAppController()

    controller.quit()

    expectEqual(controller.isTerminationRequested, true, "Quit should request app termination")
}

func testMenuBarControllerExposesSettingsAndQuitCommands() {
    let controller = MenuBarAppController()

    expectEqual(controller.availableCommands, [.openSettings, .quit], "Menu should expose settings and quit commands")
}

testNewSessionStartsIdle()
testMissingPermissionsBlocksRecording()
testRequestRecordingMovesIdleSessionToPendingRecording()
testPendingRecordingCanBeginRecording()
testRecordingCanFinishAndStartTranscribing()
testFailureCanResetToIdle()
testClosingSettingsDoesNotRequestAppTermination()
testQuitRequestsAppTermination()
testMenuBarControllerExposesSettingsAndQuitCommands()
