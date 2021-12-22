// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PalicoEngine",
    
    platforms: [
//        .macOS(.v10_14),
//        .macOS(.v11),
        .macOS(.v12),
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Palico", targets: ["Palico"]),
        .executable(name: "Editor", targets: ["Editor"]),
        .executable(name: "Example", targets: ["Example"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/forkercat/OhMyLog.git", .branch("main")),
        .package(url: "https://github.com/forkercat/MathLib.git", .branch("main")),
        .package(url: "https://github.com/forkercat/CGLFW3.git", .branch("main")),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Palico",
            dependencies: [
                .product(name: "OhMyLog", package: "OhMyLog"),
                .product(name: "MathLib", package: "MathLib"),
                .product(name: "CGLFW3", package: "CGLFW3"),
            ]),
        
        .executableTarget(name: "Editor",
            dependencies: [
                .product(name: "OhMyLog", package: "OhMyLog"),
                .product(name: "MathLib", package: "MathLib"),
                "Palico",
            ]),
        
        .executableTarget(name: "Example",
            dependencies: [
                .product(name: "OhMyLog", package: "OhMyLog"),
                "Palico",

            ]),
    ]
)
