// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AdvancedPrivacyDashboard",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "AdvancedPrivacyDashboard",
            targets: ["AdvancedPrivacyDashboard"]
        )
    ],
    dependencies: [
        // Add dependencies here as needed
    ],
    targets: [
        .executableTarget(
            name: "AdvancedPrivacyDashboard",
            dependencies: []
        ),
        .testTarget(
            name: "AdvancedPrivacyDashboardTests",
            dependencies: ["AdvancedPrivacyDashboard"]
        )
    ]
) 