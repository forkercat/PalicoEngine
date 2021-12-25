//
//  ViewController.swift
//  Palico
//
//  Created by Junhao Wang on 12/24/21.
//

import MetalKit

class ViewController: NSViewController {
    let mtkView = MTKView()
    
    override func loadView() {
        mtkView.wantsLayer = true
        mtkView.layer?.backgroundColor = .black
        self.view = mtkView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView.device = MetalContext.shared.device
    }
}
