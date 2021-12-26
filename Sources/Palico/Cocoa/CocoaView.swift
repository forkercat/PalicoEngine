//
//  CocoaView.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa
import MetalKit

@available(OSX 10.11, *)
class CocoaView: NSObject, View {
    var width:      UInt32 { UInt32(nativeView.bounds.width) }
    var height:     UInt32 { UInt32(nativeView.bounds.height) }
    var nativeView: MTKView { get { mtkView } }
    
    weak var viewDelegate: ViewDelegate?
    
    private let mtkView: MTKView
    
    override init() {
        mtkView = MTKView()
        mtkView.wantsLayer = true
        mtkView.layer?.backgroundColor = .black
        mtkView.device = MetalContext.shared.device
        
        super.init()
        
        mtkView.delegate = self
        mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
    }
    
    func setPreferredFPS(as fps: Int) {
        mtkView.preferredFramesPerSecond = fps
    }
}

@available(OSX 10.11, *)
extension CocoaView: MTKViewDelegate {
    func draw(in view: MTKView) {
        viewDelegate?.viewShouldStartDrawing(in: self)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewDelegate?.onViewResize(width: UInt32(size.width), height: UInt32(size.height))
    }
}

// Not using NSViewController
