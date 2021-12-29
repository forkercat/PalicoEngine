//
//  MetalContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MetalKit

@available(OSX 10.11, *)
class MetalContext: NSObject, GraphicsContextDelegate {
    override init() { }
    
    private(set) static var device: MTLDevice!
    private(set) static var commandQueue: MTLCommandQueue!
    private(set) static var mtkView: MTKView!
    private(set) static var library: MTLLibrary!
    
    var view: View { Self.mtkView! }
    
    var viewUpdateCallback: ViewUpdateCallback? = nil
    var viewResizeCallback: ViewResizeCallback? = nil
    
    func initialize() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue()
        else {
            assertionFailure("Device and command queue are not properly initialized!")
            Self.device = nil
            Self.commandQueue = nil
            Self.mtkView = nil
            return
        }
        Self.device = device
        Self.commandQueue = queue
        Self.mtkView = MTKView()
        
        // Configuration
        Self.mtkView.device = device
        Self.mtkView.wantsLayer = true
        Self.mtkView.layer?.backgroundColor = .black
        Self.mtkView.delegate = self
        
        // Info
        Log.info("Metal Info: \(device.name)")
    }
    
    func setViewCallbacks(update updateCallback: @escaping () -> Void,
                          resize resizeCallback: @escaping (UInt32, UInt32) -> Void) {
        viewUpdateCallback = updateCallback
        viewResizeCallback = resizeCallback
    }
    
    func deinitialize() {
        Self.device = nil
        Self.commandQueue = nil
        Self.mtkView = nil
    }
    
    static func updateShaderLibrary(_ library: MTLLibrary) {
        Self.library = library
    }
}

// MARK: - Wrapper for API-specific devices/components
// Protocol Wrapper
@available(OSX 10.11, *)
extension MTKView: View {
    var view: View {
        return self
    }
}

// View Update
@available(OSX 10.11, *)
extension MetalContext: MTKViewDelegate {
    func draw(in view: MTKView) {
        viewUpdateCallback?()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewResizeCallback?(UInt32(size.width), UInt32(size.height))
    }
}
