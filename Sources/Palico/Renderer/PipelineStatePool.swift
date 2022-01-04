//
//  PipelineStatePool.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import MetalKit

class PipelineStatePool {
    private(set) static var shared: PipelineStatePool = PipelineStatePool()
    
    var colorPipelineState: MTLRenderPipelineState!
    var shadowPipelineState: MTLRenderPipelineState!
    var geometryPipelineState: MTLRenderPipelineState!
    
    private init() {
        buildColorPipelineState()
        buildShadowPipelineState()
        geometryPipelineState = nil
    }
    
    func fetchPipelineState(type: RenderPassType) -> MTLRenderPipelineState {
        switch type {
        case .colorPass:
            return colorPipelineState
        case .shadowPass:
            return shadowPipelineState
        default:
            fatalError("Unsupported pipeline state!")
        }
    }
    
    private func buildColorPipelineState() {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = MetalContext.library.makeFunction(name: "Palico::vertex_main")
        descriptor.fragmentFunction = MetalContext.library.makeFunction(name: "Palico::fragment_main")
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Mesh.defaultVertexDescriptor)
        
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
        descriptor.vertexFunction = MetalContext.library.makeFunction(name: "Palico::vertex_main")
        descriptor.fragmentFunction = MetalContext.library.makeFunction(name: "Palico::fragment_main")
        descriptor.colorAttachments[0].pixelFormat = .invalid
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Mesh.defaultVertexDescriptor)

        do {
            shadowPipelineState = try MetalContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            assertionFailure(error.localizedDescription)
            return
        }
    }
}
