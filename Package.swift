// swift-tools-version:5.3
import PackageDescription

// Dependencies
let OhMyLog = Target.Dependency.product(name: "OhMyLog", package: "OhMyLog")
let MathLib = Target.Dependency.product(name: "MathLib", package: "MathLib")
let MothECS = Target.Dependency.product(name: "MothECS", package: "MothECS")
let ImGui = Target.Dependency.product(name: "ImGui", package: "SwiftImGui")
let ImGuizmo = Target.Dependency.product(name: "ImGuizmo", package: "SwiftImGuizmo")
// let CGLFW3 = Target.Dependency.product(name: "CGLFW3", package: "CGLFW3")

// Engine Dependencies
let engineDependencies: [Target.Dependency] = [
    OhMyLog, MathLib, MothECS, ImGui, ImGuizmo
]

// Application Dependencies
let appDependencies: [Target.Dependency] = [
    OhMyLog, MathLib, MothECS, ImGui, ImGuizmo
]

let package = Package(
    name: "PalicoEngine",
    
    platforms: [
        .macOS(.v11)
    ],
    
    products: [
        .library(name: "Palico", targets: ["Palico"]),
        .executable(name: "Editor", targets: ["Editor"]),
        .executable(name: "Example", targets: ["Example"]),
    ],
    
    dependencies: [
        // .package(url: "https://github.com/forkercat/CGLFW3.git", .branch("main")),
        .package(url: "https://github.com/forkercat/OhMyLog.git", .branch("main")),
        .package(url: "https://github.com/forkercat/MathLib.git", .branch("main")),
        .package(url: "https://github.com/forkercat/MothECS.git", .branch("main")),
        .package(url: "https://github.com/forkercat/SwiftImGui.git", .branch("update-1.86-docking")),
        .package(url: "https://github.com/forkercat/SwiftImGuizmo.git", .branch("master")),
    ],
    
    targets: [
        .target(name: "Palico",
            dependencies: engineDependencies + [
                
            ],
            exclude: ["Platform/GLFW/README.md"],
            resources: [
                .copy("Assets/")
            ]),
        
        .target(name: "Editor",
            dependencies: appDependencies + [
                "Palico"
            ],
            resources: [
                .copy("Assets/")
            ]),
        
        .target(name: "Example",
            dependencies: appDependencies + [
                "Palico",
            ]),
    ]
)
