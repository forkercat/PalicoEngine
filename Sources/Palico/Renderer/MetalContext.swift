//
//  MetalContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/18/21.
//

import MetalKit

class MetalContext {
    private static var _device: MTLDevice?
    static var device: MTLDevice { get {
        if _device == nil {
            guard let dev = MTLCreateSystemDefaultDevice() else {
                assertionFailure("Device is not properly initialized!")
                exit(1)
            }
            _device = dev
        }
        return _device!
    }}
    
    private static var _commandQueue: MTLCommandQueue?
    static var commandQueue: MTLCommandQueue { get {
        if _commandQueue == nil {
            guard let queue = device.makeCommandQueue() else {
                assertionFailure("Command queue is not properly initialized!")
                exit(1)
            }
            _commandQueue = queue
        }
        return _commandQueue!
    }}
    
    private(set) static var currentDrawable: CAMetalDrawable?
    
    static func updateDrawable(drawable: CAMetalDrawable?) {
        Self.currentDrawable = drawable
    }

//    func beginCommandBuffer() {
//
//    }
//
//    func endCommandBuffer() {
//
//    }
}
