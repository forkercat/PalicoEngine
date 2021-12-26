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
    
    private(set) var device: MTLDevice!
    private(set) var commandQueue: MTLCommandQueue!
    private(set) var mtkView: MTKView!
    
    var canvas: Canvas { self.mtkView! }
    
    var canvasUpdateCallback: CanvasUpdateCallback? = nil
    var canvasResizeCallback: CanvasResizeCallback? = nil
    
    func initialize() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue()
        else {
            assertionFailure("Device and command queue are not properly initialized!")
            self.device = nil
            self.commandQueue = nil
            self.mtkView = nil
            return
        }
        self.device = device
        self.commandQueue = queue
        self.mtkView = MTKView()
        
        // Configuration
        mtkView.device = device
        mtkView.wantsLayer = true
        mtkView.layer?.backgroundColor = .black
        mtkView.delegate = self
    }
    
    func setCanvasCallbacks(update updateCallback: @escaping () -> Void,
                            resize resizeCallback: @escaping (UInt32, UInt32) -> Void) {
        canvasUpdateCallback = updateCallback
        canvasResizeCallback = resizeCallback
    }
    
    func deinitialize() {
        device = nil
        commandQueue = nil
        mtkView = nil
    }
}

// MARK: - Wrapper for API-specific devices/components
// Protocol Wrapper
@available(OSX 10.11, *)
extension MTKView: Canvas {
    var canvas: Canvas {
        return self
    }
}

// Canvas Update
@available(OSX 10.11, *)
extension MetalContext: MTKViewDelegate {
    func draw(in view: MTKView) {
        canvasUpdateCallback?()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        canvasResizeCallback?(UInt32(size.width), UInt32(size.height))
    }
}
