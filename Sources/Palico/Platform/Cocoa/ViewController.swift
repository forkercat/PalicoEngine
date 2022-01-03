//
//  ViewController.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import Cocoa
import MetalKit

typealias MouseEventCallback = (NSEvent) -> Void
typealias ViewDrawCallback = () -> Void
typealias ViewResizeCallback = (UInt32, UInt32) -> Void

class ViewController: NSViewController {
    let mtkView = MTKView()
    
    var mouseEventCallback: MouseEventCallback? = nil
    var viewDrawCallback: ViewDrawCallback? = nil
    var viewResizeCallback: ViewResizeCallback? = nil
    
    override func loadView() {
        mtkView.device = MetalContext.device
        mtkView.wantsLayer = true
        mtkView.layer?.backgroundColor = .black
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        mtkView.delegate = self
        MetalContext.updateMTKView(mtkView)
        
        self.view = mtkView
    }
    
    // Mouse
    override func mouseMoved(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseUp(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func scrollWheel(with event: NSEvent) {
        mouseEventCallback?(event)
    }
}

extension ViewController: MTKViewDelegate {
    func draw(in view: MTKView) {
        viewDrawCallback?()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewResizeCallback?(UInt32(size.width), UInt32(size.height))
    }
}
