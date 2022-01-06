//
//  Renderer.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import Metal
import MathLib

enum RenderConfig {
    enum PixelFormat {
        static let color: MTLPixelFormat = .rgba8Unorm
        static let depth: MTLPixelFormat = .depth32Float
        static let depthStencil: MTLPixelFormat = .depth32Float_stencil8
        static let normal: MTLPixelFormat = .rgba16Float
        static let position: MTLPixelFormat = .rgba16Float
    }
}

public class Renderer {
    private(set) static var commandQueue: MTLCommandQueue? = nil
    private(set) static var commandBuffer: MTLCommandBuffer? = nil  // created at the beginning of each frame
    private(set) static var renderCommandEncoder: MTLRenderCommandEncoder? = nil  // created in begin render pass
    
    private static var depthStencilState: MTLDepthStencilState! = nil
    
    public static var currentCommandBuffer: MTLCommandBuffer? {
        return commandBuffer
    }
    
    public static let dpi: Int = Int(MetalContext.dpi)
    
    private init() {
        
    }
    
    public static func initialize() {
        // Command Queue
        guard let queue = MetalContext.commandQueue else {
            assertionFailure("Cannot make command queue from Metal device!")
            return
        }
        commandQueue = queue
        
        // Load Shaders
        guard let mainURL = FileUtils.getURL(path: "Assets/Shaders/Main.metal")
        else {
            Log.warn("Failed to load get shader URLs!")
            return
        }
        ShaderLibrary.add(name: "Main", url: mainURL)
        ShaderLibrary.compileAll()
        
        // Stencil State
        depthStencilState = Self.buildDepthStencilState()
        
        // RenderPass & PipelineState
        _ = RenderPassPool.shared
        _ = PipelineStatePool.shared
    }
    
    // Create command buffer
    public static func begin() {
        guard let buffer = commandQueue?.makeCommandBuffer() else {
            assertionFailure("Cannot make command queue from Metal device!")
            return
        }
        commandBuffer = buffer
    }
        
    // Create command encoder
    public static func beginRenderPass(type: RenderPassType,
                                       begin beginAction: RenderPassBeginAction = .clear,
                                       end endAction: RenderPassEndAction = .store) {
        // Get render pass
        let renderPass = RenderPassPool.shared.fetchRenderPass(type: type)
        guard let renderPassDescriptor = renderPass.descriptor else {
            Log.error("Cannot get render pass descriptor. Skipping rendering!")
            return
        }
        
        // TODO: REMOVE TESTING
        // renderPass.descriptor = MetalContext.view.currentRenderPassDescriptor!
        
        // Action Configurations
        renderPassDescriptor.colorAttachments[0].loadAction = convertMTLLoadAction(beginAction)
        renderPassDescriptor.depthAttachment.loadAction = convertMTLLoadAction(beginAction)
        renderPassDescriptor.colorAttachments[0].storeAction = convertMTLStoreAction(endAction)
        renderPassDescriptor.depthAttachment.storeAction = convertMTLStoreAction(endAction)
        
        // Get command encoder
        guard let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError("Cannot create render pass (MTLRenderEncoder) as command buffer is not created!")
        }
        
        // Get pipeline state & depth stencil state
        let renderPipelineState = PipelineStatePool.shared.fetchPipelineState(type: type)
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setDepthStencilState(depthStencilState)

        // Configure render encoder
        
        
        // Set as current encoder (used in render step)
        renderCommandEncoder = encoder
    }
    
    public static func render(gameObject: GameObject) {
        guard let encoder = renderCommandEncoder else {
            Log.warn("Render command encoder is nil!")
            return
        }
        
        // Get all MeshRendererComponent
        let component = gameObject.getComponent(at: 2)
        if let meshRenderer = component as? MeshRendererComponent {
            meshRenderer.onRender(encoder: encoder)
        } else {
            Log.error("It is not a mesh renderer component!")
        }
    }
    
    public static func endRenderPass() {
        renderCommandEncoder?.endEncoding()
    }
    
    public static func end() {
        guard let drawable = MetalContext.view.currentDrawable else {
            Log.warn("Drawable is nil!")
            return
        }
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    public static func getRenderPass(type: RenderPassType = .colorPass) -> RenderPass {
        return RenderPassPool.shared.fetchRenderPass(type: type)
    }
    
    public static func resizeRenderPass(type: RenderPassType = .colorPass, size: Int2) {
        let renderPass = RenderPassPool.shared.fetchRenderPass(type: type)
        renderPass.resizeTextures(size: size)
    }
    
    // Depth Stencil
    private static func buildDepthStencilState() -> MTLDepthStencilState {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return MetalContext.device.makeDepthStencilState(descriptor: descriptor)!
    }
}
