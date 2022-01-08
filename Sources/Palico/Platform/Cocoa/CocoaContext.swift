//
//  CocoaContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) { }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

class CocoaContext: PlatformContextDelegate {
    let appDelegate: AppDelegate = AppDelegate()
    
    init() { }
    
    var isAppRunning: Bool { NSApp.isRunning }
    var isAppActive: Bool { NSApp.isActive }
    var currentTime: Double { CFAbsoluteTimeGetCurrent() }
    
    func initialize() {
        _ = NSApplication.shared
        NSApp.delegate = appDelegate
        NSApp.setActivationPolicy(.regular)
    }
    
    func activate() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.run()
    }
    
    func deinitialize() {
        NSApp.deactivate()
        NSApp.stop(nil)
    }
}
