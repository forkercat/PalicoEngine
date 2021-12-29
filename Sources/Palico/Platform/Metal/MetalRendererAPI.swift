//
//  MetalRendererAPI.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import MetalKit

class MetalRendererAPI: RendererAPIImplDelegate {
    init() { }
    
    private(set) var commandQueue: MTLCommandQueue? = nil
    
    private(set) var commandBuffer: MTLCommandBuffer? = nil  // created at the beginning of each frame
    private(set) var renderEncoder: MTLRenderCommandEncoder? = nil  // created in begin render pass
    
    private let renderPassResource: MetalRenderPass = MetalRenderPass()
    private let pipelineStateResource: MetalPipelineState = MetalPipelineState()
    
    private var depthStencilState: MTLDepthStencilState! = nil
    
    func initialize() {
        // Command Queue
        guard let queue = MetalContext.commandQueue else {
            fatalError("Cannot make command queue from Metal device!")
        }
        commandQueue = queue
        
        // Load Shaders
        ShaderLibrary.add(name: "Phong", url: FileUtils.getURL(path: "Assets/Shaders/Phong.metal"))
        ShaderLibrary.add(name: "PBR", url: FileUtils.getURL(path: "Assets/Shaders/PBR.metal"))
        ShaderLibrary.compileAll()
        
        buildDepthStencilState()
    }
    
    func makeCommandBuffer() {
        guard let buffer = commandQueue?.makeCommandBuffer() else {
            fatalError("Cannot make command buffer!")
        }
        commandBuffer = buffer
    }
    
    func beginRenderPass(type: RenderPassType, target: RenderPassTarget) {
        // Get render pass
        let renderPassDescriptor = renderPassResource.fetchRenderPassDescriptor(type: type, target: target)
        
        // Get render encoder
        guard let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError("Cannot create render pass (MTLRenderEncoder) as command buffer is not created!")
        }
        
        // Get pipeline state & depth stencil state
        let renderPipelineState = pipelineStateResource.fetchPipelineState(type: type)
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setDepthStencilState(depthStencilState)
        
        // Configure render encoder
        
        
        // Set as current encoder (used in render step)
        renderEncoder = encoder
    }
    
    func render(/* renderable */) {
        // Render Triangle
        
    }
    
    func endRenderPass() {  // no checking
        renderEncoder?.endEncoding()
    }
    
    func submitCommandBuffer() {  // no checking
        if let drawable = MetalContext.mtkView.currentDrawable {
            commandBuffer?.present(drawable)
        }
    }
    
    // Depth Stencil
    private func buildDepthStencilState() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        
        depthStencilState = MetalContext.device.makeDepthStencilState(descriptor: descriptor)!
    }
}

