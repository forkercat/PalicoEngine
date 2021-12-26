////
////  CocoaApplication.swift
////  Palico
////
////  Created by Junhao Wang on 12/25/21.
////
//
//import Cocoa
//
//open class CocoaApplication: Application {
//    let appDelegate: AppDelegate
//
//    public override init(name: String = "Palico Engine v1.0.0 (Cocoa)", arguments: [String] = []) {
//        // self properties
//        Log.registerLogger(name: "Palico", level: .trace)
//        Log.info("Arguments[1:]: \(arguments.dropFirst())")
//
//        // Applicaiton
//        assert(Application.instance == nil, "Only one application is allowed!")
//        defer { Application.instance = self }
//
//        _ = NSApplication.shared
//        appDelegate = AppDelegate()
//        NSApp.delegate = appDelegate
//        NSApp.setActivationPolicy(.regular)
//
//        let width: UInt32 = 1280
//        let height: UInt32 = 720
//
//        // Window
//        let windowDescriptor = WindowDescriptor(title: name, width: width, height: height)
//        window = CocoaWindow(descriptor: windowDescriptor)
//        defer { window.windowDelegate = self }
//
//        // Renderer
//
//        // ImGui
//        imGuiLayer = ImGuiLayer()
//        pushOverlay(imGuiLayer)
//        
//
//
//
//        super.init(name: name, arguments: arguments)  // push layer
//
//
//    }
//
//    public override func run() {
//        NSApp.activate(ignoringOtherApps: true)
//        NSApp.run()
//    }
//
//    public override func close() {
//        NSApp.deactivate()
//        NSApp.stop(nil)
//    }
//}
