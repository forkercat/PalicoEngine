//
//  ViewController.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import Cocoa
import MetalKit
import MathLib

typealias MouseEventCallback = (NSEvent) -> Void
typealias ViewDrawCallback = () -> Void
typealias ViewResizeCallback = (Int2) -> Void

class ViewController: NSViewController {
    let mtkView = MTKView()
    
    var mouseEventCallback: MouseEventCallback? = nil
    var viewDrawCallback: ViewDrawCallback? = nil
    var viewResizeCallback: ViewResizeCallback? = nil
    
    override func loadView() {
        mtkView.device = MetalContext.device
        mtkView.wantsLayer = true
        mtkView.layer?.backgroundColor = .black
        mtkView.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
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
        viewResizeCallback?(Int2(Int(size.width), Int(size.height)))
    }
}
