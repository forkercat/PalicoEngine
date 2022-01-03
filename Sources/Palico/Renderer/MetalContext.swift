//
//  MetalContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MetalKit

class MetalContext {
    private(set) static var device: MTLDevice! = nil
    private(set) static var commandQueue: MTLCommandQueue! = nil
    private(set) static var library: MTLLibrary! = nil
    
    private(set) static var view: MTKView! = nil
    
    static var dpi: Float { Float(Self.view?.window?.screen?.backingScaleFactor ?? 1.0) }
    
    static func initialize() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue()
        else {
            assertionFailure("Device and command queue are not properly initialized!")
            return
        }
        Self.device = device
        Self.commandQueue = queue
    
        // Info
        Log.info("Metal Info: \(device.name)")
    }
    
    func deinitialize() {
        Self.device = nil
        Self.commandQueue = nil
        Self.library = nil
    }
    
    static func updateShaderLibrary(_ library: MTLLibrary) {
        Self.library = library
    }
    
    static func updateMTKView(_ mtkView: MTKView) {
        Self.view = mtkView
    }
}
