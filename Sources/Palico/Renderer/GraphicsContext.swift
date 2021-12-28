//
//  GraphicsContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

typealias ViewUpdateCallback = () -> Void
typealias ViewResizeCallback = (UInt32, UInt32) -> Void

protocol GraphicsContextDelegate {
    var view: View { get }
    
    func initialize()
    func setViewCallbacks(update updateCallback: @escaping ViewUpdateCallback,
                          resize resizeCallback: @escaping ViewResizeCallback)
    func deinitialize()
}

// Internal Usage
struct GraphicsContext {
    private static let contextDelegate = MetalContext()
    
    static var view: View { get {
        return Self.contextDelegate.view
    }}
    
    static func initialize() {
        return Self.contextDelegate.initialize()
    }
    
    static func setCanvasCallbacks(update updateCallback: @escaping ViewUpdateCallback,
                                  resize resizeCallback: @escaping ViewResizeCallback) {
        return Self.contextDelegate.setViewCallbacks(update: updateCallback,
                                                     resize: resizeCallback)
    }
    
    static func deinitialize() {
        return Self.contextDelegate.deinitialize()
    }
    
    private init() { }
}

// Wrapper for API-specific devices/components
// Protocol Wrapper
protocol View {
    var view: View { get }
}
