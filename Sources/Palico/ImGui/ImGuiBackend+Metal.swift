//
//  ImGuiBackend+Metal.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import Metal
import ImGui

class ImGuiBackendMetalGraphics: ImGuiBackendGraphicsDelegate {
    private(set) var commandBuffer: MTLCommandBuffer!
    private(set) var renderCommandEncoder: MTLRenderCommandEncoder!
    
    init() { }
    
    func implGraphicsInit() {
        ImGui_ImplMetal_Init(MetalContext.device)
    }
    
    func implGraphicsNewFrame() {
        guard let mtkView = MetalContext.view,
              let commandBuffer = Renderer.currentCommandBuffer,
              let renderPassDescriptor = mtkView.currentRenderPassDescriptor
        else {
            Log.warn("ImplGraphicsNewFrame: Required resources are not available!")
            return
        }
        
        self.commandBuffer = commandBuffer
        
        // Config
        let io = ImGuiGetIO()!
        let dpi: Float = MetalContext.dpi
        io.pointee.DisplayFramebufferScale = ImVec2(dpi, dpi)
        io.pointee.DisplaySize = ImVec2(Float(mtkView.bounds.width), Float(mtkView.bounds.height))
        io.pointee.DeltaTime = Time.deltaTime

        // Keeping results from other render passes that run first
        /*
        renderPassDescriptor.colorAttachments[0].loadAction = .load
        renderPassDescriptor.depthAttachment.loadAction = .load
         */
        
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        commandEncoder.pushDebugGroup("ImGui Layer")
        
        renderCommandEncoder = commandEncoder
        
        ImGui_ImplMetal_NewFrame(renderPassDescriptor)
    }
    
    func implGraphicsShutdown() {
        ImGui_ImplMetal_Shutdown()
    }
    
    func implGraphicsRenderDrawData(_ drawData: ImDrawData) {
        ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
        renderCommandEncoder.endEncoding()
    }
}
