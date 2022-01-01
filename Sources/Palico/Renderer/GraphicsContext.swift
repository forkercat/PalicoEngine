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
    var dpi: Float { get }
    
    func initialize()
    func setViewCallbacks(update updateCallback: @escaping ViewUpdateCallback,
                          resize resizeCallback: @escaping ViewResizeCallback)
    func deinitialize()
}

// Internal Usage
struct GraphicsContext {
    private static var contextDelegate: GraphicsContextDelegate!
    
    private init() { }
    
    static var view: View { get {
        return contextDelegate.view
    }}
    
    static var dpi: Float { get {
        return contextDelegate.dpi
    }}
    
    static func initialize() {
        let api = RendererAPI.getAPI()
        switch api {
        case .metal:
            contextDelegate = MetalContext()
        default:
            assertionFailure("API (\(api)) is not supported!")
            return
        }
        contextDelegate.initialize()
    }
    
    static func setViewCallbacks(update updateCallback: @escaping ViewUpdateCallback,
                                 resize resizeCallback: @escaping ViewResizeCallback) {
        return contextDelegate.setViewCallbacks(update: updateCallback,
                                                resize: resizeCallback)
    }
    
    static func deinitialize() {
        return contextDelegate.deinitialize()
    }
}

// Wrapper for API-specific devices/components
// Protocol Wrapper
protocol View {
    var view: View { get }
}
