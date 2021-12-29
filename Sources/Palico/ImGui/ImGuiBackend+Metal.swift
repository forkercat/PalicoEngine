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
        guard let mtkView = MetalContext.mtkView,
              let commandBuffer = MetalContext.commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = mtkView.currentRenderPassDescriptor
        else {
            Log.warn("ImplGraphicsNewFrame: Required resources are not available!")
            return
        }
        
        self.commandBuffer = commandBuffer
        
        // Config
        let io = ImGuiGetIO()!
        let frameBufferScale = Float(mtkView.window?.screen?.backingScaleFactor ?? 1.0)
        io.pointee.DisplayFramebufferScale = ImVec2(x: frameBufferScale, y: frameBufferScale)
        io.pointee.DisplaySize = ImVec2(x: Float(mtkView.bounds.width), y: Float(mtkView.bounds.height))
        io.pointee.DeltaTime = 1.0 / Float(mtkView.preferredFramesPerSecond)

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
        commandBuffer.present(MetalContext.mtkView.currentDrawable!)
        commandBuffer.commit()
    }
}
