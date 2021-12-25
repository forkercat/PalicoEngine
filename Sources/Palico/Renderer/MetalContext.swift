//
//  MetalContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/18/21.
//

import MetalKit

class MetalContext {
    private(set) static var shared = MetalContext()
    
    let device: MTLDevice!
    let commandQueue: MTLCommandQueue!
    
    private init() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue()
        else {
            assertionFailure("Device and command queue are not properly initialized!")
            self.device = nil
            self.commandQueue = nil
            return
        }
        self.device = device
        self.commandQueue = queue
    }
}
