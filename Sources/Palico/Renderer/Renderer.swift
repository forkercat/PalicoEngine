//
//  Renderer.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import Metal

public class Renderer {
    private(set) static var commandQueue: MTLCommandQueue? = nil
    
    private(set) static var commandBuffer: MTLCommandBuffer? = nil  // created at the beginning of each frame
    private(set) static var renderEncoder: MTLRenderCommandEncoder? = nil  // created in begin render pass
    
    private static let renderPassResource: RenderPass = RenderPass()
    private static let pipelineStateResource: MetalPipelineState = MetalPipelineState()
    
    private static var depthStencilState: MTLDepthStencilState! = nil
    
    public static func initialize() {
        // Command Queue
        guard let queue = MetalContext.commandQueue else {
            assertionFailure("Cannot make command queue from Metal device!")
            return
        }
        commandQueue = queue
        
        // Stencil State
        depthStencilState = Self.buildDepthStencilState()
        
        // RenderPass
        
        // Load Shaders
        guard let phongURL = FileUtils.getURL(path: "Assets/Shaders/Phong.metal"),
              let pbrURL = FileUtils.getURL(path: "Assets/Shaders/PBR.metal")
        else {
            Log.warn("Failed to load get shader URLs!")
            return
        }
        ShaderLibrary.add(name: "Phong", url: phongURL)
        ShaderLibrary.add(name: "PBR", url: pbrURL)
        ShaderLibrary.compileAll()
    }
    
    public static func begin() {
        guard let buffer = commandQueue?.makeCommandBuffer() else {
            assertionFailure("Cannot make command queue from Metal device!")
            return
        }
        commandBuffer = buffer
    }
    
    public static func beginRenderPass(type: RenderPassType, target: RenderPassTarget) {
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
    
    public static func render(/* something renderable */) {
        // if metal renderable
        //     renderable.render(MTLEncoder)
    }
    
    public static func endRenderPass() {
        renderEncoder?.endEncoding()
    }
    
    public static func end() {
        guard let drawable = MetalContext.view.currentDrawable else {
            Log.warn("Drawable is nil!")
            return
        }
        commandBuffer?.present(drawable)
    }
    
    // Depth Stencil
    private static func buildDepthStencilState() -> MTLDepthStencilState {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return MetalContext.device.makeDepthStencilState(descriptor: descriptor)!
    }
}
