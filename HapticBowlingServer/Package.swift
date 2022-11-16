// swift-tools-version:4.2

import PackageDescription

let package = Package(
	name: "HapticBowlingServer",
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", from: "3.0.0"),
	],
	targets: []
)
