// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Dependencies
let OhMyLog = Target.Dependency.product(name: "OhMyLog", package: "OhMyLog")
let MathLib = Target.Dependency.product(name: "MathLib", package: "MathLib")
let ImGui = Target.Dependency.product(name: "ImGui", package: "SwiftImGui")
let CGLFW3 = Target.Dependency.product(name: "CGLFW3", package: "CGLFW3")

// Engine Dependencies
let engineDependencies: [Target.Dependency] = [
    OhMyLog, MathLib, ImGui, CGLFW3,
]

// Application Dependencies
let appDependencies: [Target.Dependency] = [
    OhMyLog, MathLib, ImGui,
]

let package = Package(
    name: "PalicoEngine",
    
    platforms: [
//        .macOS(.v10_14),
//        .macOS(.v11),
        .macOS(.v12),
    ],
    
    products: [
        .library(name: "Palico", targets: ["Palico"]),
        .executable(name: "Editor", targets: ["Editor"]),
        .executable(name: "Example", targets: ["Example"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/forkercat/OhMyLog.git", .branch("main")),
        .package(url: "https://github.com/forkercat/MathLib.git", .branch("main")),
        .package(url: "https://github.com/forkercat/CGLFW3.git", .branch("main")),
        .package(url: "https://github.com/ctreffs/SwiftImGui.git", .branch("docking")),
    ],
    
    targets: [
        .target(name: "Palico",
            dependencies: engineDependencies + [
                
            ],
            exclude: ["Platform/GLFW/README.md"]),
        
        .executableTarget(name: "Editor",
            dependencies: appDependencies + [
                "Palico"
            ]),
        
        .executableTarget(name: "Example",
            dependencies: appDependencies + [
                "Palico",
            ]),
    ]
)
