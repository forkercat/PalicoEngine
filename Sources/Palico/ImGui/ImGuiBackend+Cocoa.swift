//
//  ImGuiBackend+Cocoa.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import Cocoa

class ImGuiBackendCocoaPlatform: ImGuiBackendPlatformDelegate {
    init() { }
    
    func implPlatformInit() {
        ImGui_ImplOSX_Init(GraphicsContext.view as! NSView)
    }
    
    func implPlatformNewFrame() {
        ImGui_ImplOSX_NewFrame(GraphicsContext.view as! NSView)
    }
    
    func implPlatformShutdown() { }
}
