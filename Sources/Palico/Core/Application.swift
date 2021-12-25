//
//  Application.swift
//  
//
//  Created by Junhao Wang on 12/15/21.
//

import AppKit
import MetalKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) { }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

open class Application {
    private(set) static var instance: Application?
    
    private var layerStack: LayerStack = LayerStack()
    
    let appDelegate: AppDelegate
    let window: Window
    
    public init(name: String = "Palico Engine", arguments: [String] = []) {
        Log.registerLogger(name: "Palico", level: .trace)
        Log.info("Arguments[1:]: \(arguments.dropFirst())")
        
        // Applicaiton
        assert(Application.instance == nil, "Only one application is allowed!")
        defer { Application.instance = self }
        
        _ = NSApplication.shared
        appDelegate = AppDelegate()
        NSApp.delegate = appDelegate
        NSApp.setActivationPolicy(.regular)
        
        let width: UInt32 = 960
        let height: UInt32 = 540
        
        // Window (ViewController & MTKView)
        let windowDescriptor = WindowDescriptor(title: name, width: width, height: height)
        window = Window(descriptor: windowDescriptor)
        window.windowDelegate = self
        window.makeMain()
        
        // Renderer
        
        // ImGui
    }
    
    public func run() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.run()
    }
    
    public func close() {
        NSApp.deactivate()
        NSApp.stop(nil)
    }
}

// Window Delegate
extension Application: WindowDelegate {
    func onUpdate(deltaTime: Timestep) {
        guard NSApp.isRunning && !window.nsWindow.isMiniaturized else {
            return
        }
        
        if false {  // show FPS?
            Log.debug("FPS: \(Int(1.0 / deltaTime))")
        }
        
        // - 1. Layer Update
        for layer in layerStack.layers {
            layer.onUpdate(deltaTime: deltaTime)
        }
        
        // - 2. Layer ImGuiRender
        // ImGuiLayer.begin()
        for layer in layerStack.layers {
            layer.onUpdate(deltaTime: deltaTime)
        }
        // ImGuiLayer.end()
    }
    
    func onEvent(event: Event) {
        let dispatcher = EventDispatcher(event: event)
        
        // 1. Application Level
        dispatcher.dispatch(callback: onWindowClose)
        dispatcher.dispatch(callback: onWindowViewResize)
        dispatcher.dispatch(callback: onEscPressedForDebugging)
        
        // 2. Layer Level
        // Process events in layers (reversed order) Ex: [back, ..., front]
        for layer in layerStack.layers.reversed() {
            if event.handled {
                break
            }
            layer.onEvent(event: event)
        }
    }
    
    private func onWindowClose(event: WindowCloseEvent) -> Bool {
        close()
        return true
    }
    
    private func onEscPressedForDebugging(event: KeyPressedEvent) -> Bool {
        if event.key == .escape {
            close()
            return true
        } else {
            return false
        }
    }
    
    private func onWindowViewResize(event: WindowViewResizeEvent) -> Bool {
        if event.width == 0 || event.height == 0 {
            Log.warn("Window view size is 0. Do not updating.")
            return false
        }
        
        // Renderer Resize
        // Ex: Renderer::onWindowViewResize
        
        return false
    }
}

// Layer
extension Application {
    public func pushLayer(_ layer: Layer) {
        layerStack.pushLayer(layer)
        layer.onAttach()
    }
    
    public func pushOverlay(_ overlay: Layer) {
        layerStack.pushOverlay(overlay)
        overlay.onAttach()
    }
}
