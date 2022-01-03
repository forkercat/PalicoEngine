//
//  MetalPipelineState.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import Metal

// Shader
// pixelFormat
// vertexDescriptor (can be preset?)
// - phong
// - PBR
// - depth
// - geometry
// - composite

// - depthStencil
class MetalPipelineState {
    
    var colorPipelineState: MTLRenderPipelineState!
    var shadowPipelineState: MTLRenderPipelineState!
    
    init() {
//        buildColorPipelineState()
//        buildShadowPipelineState()
    }
    
    func fetchPipelineState(type: RenderPassType) -> MTLRenderPipelineState {
        switch type {
        case .colorPass:
            return colorPipelineState
        case .shadowPass:
            return shadowPipelineState
        }
    }
    
    private func buildColorPipelineState() {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = nil
        descriptor.fragmentFunction = nil
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = nil  // need to be updated

        do {
            colorPipelineState = try MetalContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            assertionFailure(error.localizedDescription)
            return
        }
    }
    
    // Shadow
    private func buildShadowPipelineState() {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = nil
        descriptor.fragmentFunction = nil
        descriptor.colorAttachments[0].pixelFormat = .invalid
        descriptor.depthAttachmentPixelFormat = .depth32Float
        
//        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Model.defaultVertexDescriptor)
        do {
            shadowPipelineState = try MetalContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            assertionFailure(error.localizedDescription)
            return
        }
    }
}
