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
    
    private static var currentRenderPassDebugName: String? = nil
    
    static var currentCommandBuffer: MTLCommandBuffer? {  // used by ImGuiBackend internally
        return commandBuffer
    }
    
    private static var vertexUniformData: VertexUniformData = VertexUniformData()
    private static var fragmentUniformData: FragmentUniformData = FragmentUniformData()
    
    public static let dpi: Int = Int(MetalContext.dpi)
    
    private init() {
        
    }
}
 
// MARK: - Pre-Render
extension Renderer {
    public static func initialize() {
        // Command Queue
        guard let queue = MetalContext.commandQueue else {
            assertionFailure("Cannot make command queue from Metal device!")
            return
        }
        commandQueue = queue
        
        // Load Shaders
        guard let commonURL = FileUtils.getURL(path: "Assets/Shaders/Common.metal"),
              let mainURL = FileUtils.getURL(path: "Assets/Shaders/Main.metal")
        else {
            Log.warn("Failed to load get shader URLs!")
            return
        }
        ShaderLibrary.add(name: "Common", url: commonURL)
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
                                       end endAction: RenderPassEndAction = .store,
                                       clearColor: Color = Color(0, 0, 0, 1),
                                       clearDepth: Float = 1.0) {
        // Get render pass
        let renderPass = RenderPassPool.shared.fetchRenderPass(type: type)
        guard let renderPassDescriptor = renderPass.descriptor else {
            Log.error("Cannot get render pass descriptor. Skipping rendering!")
            return
        }
        
        // TODO: REMOVE TESTING
        /*
        MetalContext.view.colorPixelFormat = RenderConfig.PixelFormat.color
        MetalContext.view.depthStencilPixelFormat = RenderConfig.PixelFormat.depth
        renderPass.descriptor = MetalContext.view.currentRenderPassDescriptor!
         */
        
        // Action Configurations
        renderPassDescriptor.colorAttachments[0].loadAction = convertMTLLoadAction(beginAction)
        renderPassDescriptor.depthAttachment.loadAction = convertMTLLoadAction(beginAction)
        renderPassDescriptor.colorAttachments[0].storeAction = convertMTLStoreAction(endAction)
        renderPassDescriptor.depthAttachment.storeAction = convertMTLStoreAction(endAction)
        
        let clearColor = MTLClearColor(red: Double(clearColor.r), green: Double(clearColor.g),
                                       blue: Double(clearColor.b), alpha: Double(clearColor.a))
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor
        renderPassDescriptor.depthAttachment.clearDepth = Double(clearDepth)
        
        // Get command encoder
        guard let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError("Cannot create render pass (MTLRenderEncoder) as command buffer is not created!")
        }
        
        // Get pipeline state & depth stencil state
        let renderPipelineState = PipelineStatePool.shared.fetchPipelineState(type: type)
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setDepthStencilState(depthStencilState)
        
        // Debug Info
        encoder.pushDebugGroup(renderPass.name)
        currentRenderPassDebugName = renderPass.name
        
        // Set as current encoder (used in render step)
        renderCommandEncoder = encoder
    }
    
    public static func preRenderSetup(scene: Scene, camera: Camera) {
        // Camera (view & projection)
        vertexUniformData.viewMatrix = camera.viewMatrix
        vertexUniformData.projectionMatrx = camera.projectionMatrix
        
        fragmentUniformData.tintColor = Color.yellow
        
        // Lighting
        // TODO: encoder.setFragmentBytes(, length: , index: )
    }
}

// MARK: - Render
extension Renderer {
    public static func render(scene: Scene) {
        // TODO: Render a scene
        // Get a list of all MeshRendererComponents
        //   Get their game object
        //   Get transform component
        //   Setup model matrix
    }
    
    public static func render(gameObject: GameObject) {
        guard let encoder = renderCommandEncoder else {
            Log.warn("Render command encoder is nil!")
            return
        }
        
        // Get mesh renderer component
        let component1 = gameObject.getComponent(at: 2)
        guard let meshRenderer = component1 as? MeshRendererComponent else {
            Log.error("It is not a mesh renderer component!")
            return
        }
        
        // Get transform component
        let component2 = gameObject.getComponent(at: 0)
        guard let transform = component2 as? TransformComponent else {
            fatalError("Not a transform component!")
        }
        
        // Setup uniform data
        vertexUniformData.modelMatrix = transform.modelMatrix
        
        if gameObject is Cube {
            fragmentUniformData.tintColor = .yellow
        } else {
            fragmentUniformData.tintColor = .green
        }
        
        uploadUniformData(encoder)
        
        // Draw vertex
        draw(encoder, mesh: meshRenderer.mesh)
    }
    
    private static func uploadUniformData(_ encoder: MTLRenderCommandEncoder) {
        guard let encoder = renderCommandEncoder else {
            Log.warn("Render command encoder is nil!")
            return
        }
        
        encoder.setVertexBytes(&vertexUniformData,
                               length: MemoryLayout<VertexUniformData>.stride,
                               index: BufferIndex.vertexUniform.rawValue)
        
        encoder.setFragmentBytes(&fragmentUniformData,
                                 length: MemoryLayout<FragmentUniformData>.stride,
                                 index: BufferIndex.fragmentUniform.rawValue)
    }
    
    private static func draw(_ encoder: MTLRenderCommandEncoder, mesh: Mesh) {
        encoder.setVertexBuffer(mesh.nativeMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.nativeSubmesh.indexCount,
                                          indexType: submesh.nativeSubmesh.indexType,
                                          indexBuffer: submesh.nativeSubmesh.indexBuffer.buffer,
                                          indexBufferOffset: 0)
        }
    }
}

// MARK: - Post-Render
extension Renderer {
    public static func endRenderPass() {
        if currentRenderPassDebugName != nil {
            renderCommandEncoder?.popDebugGroup()
        }
        
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

// MARK: - Other
extension Renderer {
    public static func setPreferredFPS(_ fps: Int) {
        MetalContext.setPreferredFps(fps)
    }
}
