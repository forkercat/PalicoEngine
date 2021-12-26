//
//  GraphicsContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

typealias CanvasUpdateCallback = () -> Void
typealias CanvasResizeCallback = (UInt32, UInt32) -> Void

protocol GraphicsContextDelegate {
    var canvas: Canvas { get }
    
    func initialize()
    func setCanvasCallbacks(update updateCallback: @escaping CanvasUpdateCallback,
                            resize resizeCallback: @escaping CanvasResizeCallback)
    func deinitialize()
}

// Internal Usage
struct GraphicsContext {
    private static let contextDelegate = MetalContext()
    
    static var canvas: Canvas { get {
        return Self.contextDelegate.canvas
    }}
    
    static func initialize() {
        return Self.contextDelegate.initialize()
    }
    
    static func setCanvasCallbacks(update updateCallback: @escaping CanvasUpdateCallback,
                                  resize resizeCallback: @escaping CanvasResizeCallback) {
        return Self.contextDelegate.setCanvasCallbacks(update: updateCallback,
                                                       resize: resizeCallback)
    }
    
    static func deinitialize() {
        return Self.contextDelegate.deinitialize()
    }
    
    private init() { }
}

// Wrapper for API-specific devices/components
// Protocol Wrapper
protocol Canvas {
    var canvas: Canvas { get }
}
