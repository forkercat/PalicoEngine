//
//  MetalRenderPass.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import MetalKit

// RenderTarget: Texture or...
// CullMode
// label/DebugGroup
// DepthStencil
// - mtkview.renderPass
// - texture

// move to other places
public enum RenderPassType {
    case colorPass
    case shadowPass
}

public enum RenderPassTarget {
    case framebuffer
    case texture
}

private extension MTLRenderPassDescriptor {
    func setUpDepthAttachment(texture: MTLTexture) {
        depthAttachment.texture = texture
        depthAttachment.loadAction = .clear
        depthAttachment.storeAction = .store
        depthAttachment.clearDepth = 1
    }
    
    func setUpColorAttachment(position: Int, texture: MTLTexture) {
        let attachment: MTLRenderPassColorAttachmentDescriptor = colorAttachments[position]
        attachment.texture = texture
        attachment.loadAction = .clear
        attachment.storeAction = .store
        attachment.clearColor = MTLClearColorMake(0.73, 0.92, 1, 1)
    }
}

class MetalRenderPass {
    
    var colorPassDescriptor: MTLRenderPassDescriptor = MTLRenderPassDescriptor()
    var colorTexture: MTLTexture!
    
    init() {
        buildColorTexture(size: CGSize(width: 10, height: 10))
        configureColorPassDescriptor()
    }
    
    private func buildColorTexture(size: CGSize) {
        colorTexture = MetalTexture.make(pixelFormat: .bgra8Unorm, size: size, label: "Color Texture")
    }
    
    private func configureColorPassDescriptor() {
        
    }
    
    func fetchRenderPassDescriptor(type: RenderPassType, target: RenderPassTarget) -> MTLRenderPassDescriptor {
        // Descriptor
        var descriptor: MTLRenderPassDescriptor
        
        switch (type, target) {
        // Color Pass
        case (.colorPass, .framebuffer):
            descriptor = MetalContext.mtkView.currentRenderPassDescriptor!
        case (.colorPass, .texture):
            descriptor = colorPassDescriptor
            assertionFailure("Not supported yet!")
//            descriptor = colorPassDescriptor
            // check size -> recreate texture
        default:
            fatalError("Not supported yet!")
        }
        
        return descriptor
    }
}


// RenderPass
// - Target

func buildColorRenderPass() {
    
}

func buildShadowRenderPass() {
    
}


// PipelineState

