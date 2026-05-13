// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "VoiceInput",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "VoiceInputCore", targets: ["VoiceInputCore"]),
        .executable(name: "VoiceInputApp", targets: ["VoiceInputApp"]),
        .executable(name: "VoiceInputBehaviorTests", targets: ["VoiceInputBehaviorTests"])
    ],
    targets: [
        .target(name: "VoiceInputCore"),
        .executableTarget(
            name: "VoiceInputApp",
            dependencies: ["VoiceInputCore"]
        ),
        .executableTarget(
            name: "VoiceInputBehaviorTests",
            dependencies: ["VoiceInputCore"]
        ),
        .testTarget(
            name: "VoiceInputCoreTests",
            dependencies: ["VoiceInputCore"]
        )
    ]
)
