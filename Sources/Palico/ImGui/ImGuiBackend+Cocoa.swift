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
        ImGui_ImplOSX_Init(MetalContext.view)
    }
    
    func implPlatformNewFrame() {
        ImGui_ImplOSX_NewFrame(MetalContext.view)
    }
    
    func implPlatformShutdown() {
        ImGui_ImplOSX_Shutdown()
    }
}
