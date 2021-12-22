//
//  Application.swift
//  
//
//  Created by Junhao Wang on 12/15/21.
//

import Metal

open class Application {
    private(set) static var instance: Application?
    
    private(set) var window: Window
    private var layerStack: LayerStack = LayerStack()
    private var isRunning: Bool = true
    private var isMinimized: Bool = false
    
    private var lastFrameTime: Timestep = 0.0
    
    public init(name: String = "Palico Engine", arguments: [String] = []) {
        Log.registerLogger(name: "Palico", level: .trace)
        
        Log.info("Arguments[1:]: \(arguments.dropFirst())")
        
        // Applicaiton
        assert(Application.instance == nil, "Application::Only one application is allowed!")
        defer { Application.instance = self }
        
        // Window
        let windowDescriptor = WindowDescriptor(title: name, width: 640, height: 360)
        window = Window(descriptor: windowDescriptor)
        window.setEventCallback(callback: onEvent)
        
        // Renderer
        
        
        // ImGui
    }
    
    public func run() {
        while isRunning {
            // Poll Events & Swapchain updates drawable
            window.onUpdate()
            
            // Time
            let currentTime = Time.currentTime
            let deltaTime = currentTime - lastFrameTime
            lastFrameTime = currentTime

            Log.debug("FPS: \(1.0 / deltaTime)")

            // Render
            if isMinimized { return }
            
            let buffer = MetalContext.commandQueue.makeCommandBuffer()!

            let pass = MTLRenderPassDescriptor()
            pass.colorAttachments[0].texture = MetalContext.currentDrawable?.texture
            pass.colorAttachments[0].loadAction = .clear
            pass.colorAttachments[0].clearColor = MTLClearColorMake(0.2, 0.8, 0.0, 1.0)
            pass.colorAttachments[0].storeAction = .store
            let encoder = buffer.makeRenderCommandEncoder(descriptor: pass)!
            encoder.endEncoding()

            buffer.present(MetalContext.currentDrawable!)
            buffer.commit()
            
            // ...
        }
    }
    
    private func close() {
        isRunning = false
    }
    
    // Layer
    public func pushLayer(_ layer: Layer) {
        layerStack.pushLayer(layer)
        layer.onAttach()
    }
    
    public func pushOverlay(_ overlay: Layer) {
        layerStack.pushOverlay(overlay)
        overlay.onAttach()
    }
    
    public func getImGuiLayer() {
        
    }
}

// Handle Events
extension Application {

    // Event
    private func onEvent(event: Event) {
        let dispatcher = EventDispatcher(event: event)
        _ = dispatcher.dispatch(callback: onWindowClose)
        _ = dispatcher.dispatch(callback: onWindowResize)
        _ = dispatcher.dispatch(callback: onEscPressed)
        
        // Process events in layers (reversed order)
        for layer in layerStack.layers.reversed() {
            if event.handled {
                break
            }
            layer.onEvent(event: event)
        }
    }
    
    private func onWindowClose(event: WindowCloseEvent) -> Bool {
        isRunning = false
        return true
    }
    
    private func onEscPressed(event: KeyPressedEvent) -> Bool {
        if event.key == .escape {
            isRunning = false
            return true
        } else {
            return false
        }
    }
    
    private func onWindowResize(event: WindowResizeEvent) -> Bool {
        if event.width == 0 || event.height == 0 {
            isMinimized = true
            return false
        }
        
        isMinimized = false
        // Renderer Resize
        
        return false
    }
}
