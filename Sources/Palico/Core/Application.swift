//
//  Application.swift
//  Palico
//
//  Created by Junhao Wang on 12/15/21.
//

open class Application {
    private(set) static var instance: Application?

    private let layerStack: LayerStack = LayerStack()
    private let imGuiLayer: ImGuiLayer = ImGuiLayer()

    private(set) var window: Window
    
    private var lastFrameTime: Timestep = Time.currentTime
    private var deltaTime: Timestep { get {
        let currentTime = Time.currentTime
        let deltaTime = currentTime - lastFrameTime
        lastFrameTime = currentTime
        return deltaTime
    }}

    public init(name: String = "Palico Engine", arguments: [String] = []) {
        Log.registerLogger(name: "Palico", level: .trace)
        Log.info("Arguments[1:]: \(arguments.dropFirst())")

        // Applicaiton
        assert(Application.instance == nil, "Only one application is allowed!")
        defer { Application.instance = self }
        
        // Context
        Context.initialize()          // application
        GraphicsContext.initialize()  // graphics
        defer { GraphicsContext.setCanvasCallbacks(update: onUpdate, resize: onResize) }
        
        let width: UInt32 = 1280
        let height: UInt32 = 720

        // Window
        let windowDescriptor = WindowDescriptor(title: name, width: width, height: height)
        window = CocoaWindow(descriptor: windowDescriptor)
        defer { window.windowDelegate = self }

        // Renderer

        // ImGui
        pushOverlay(imGuiLayer)
    }

    public func run() { Context.activate() }
    public func close() { Context.deinitialize() }
    
    public func pushLayer(_ layer: Layer) {
        layerStack.pushLayer(layer)
        layer.onAttach()
    }

    public func pushOverlay(_ overlay: Layer) {
        layerStack.pushOverlay(overlay)
        overlay.onAttach()
    }
}

// Graphics Context Callbacks
extension Application {
    func onUpdate() {
        guard Context.isAppRunning && !window.isMinimized else {
            return
        }
        
        if false {  // show FPS?
//            Log.debug("FPS: \(Int(1.0 / deltaTime))")
        }
        
        // - 1. Layer Update
        for layer in layerStack.layers {
            layer.onUpdate(deltaTime: deltaTime)
        }

        // - 2. Layer ImGuiRender
//        imGuiLayer.begin(in: view)
//        for layer in layerStack.layers {
//            layer.onImGuiRender()
//        }
//        imGuiLayer.end()
    }
    
    func onResize(width: UInt32, height: UInt32) {
        let event = WindowViewResizeEvent(width: width, height: height)
        onEvent(event: event)
    }
}

// Window Delegate
extension Application: WindowDelegate {
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
