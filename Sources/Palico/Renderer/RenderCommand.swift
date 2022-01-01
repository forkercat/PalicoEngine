//
//  RenderCommand.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

public struct RenderCommand {
    private static let rendererAPI: RendererAPIImplDelegate? = RendererAPI.create()
    
    public static func initialize() {
        rendererAPI?.initialize()
    }
    
    // For each frame
    public static func makeCommandBuffer() {
        rendererAPI?.makeCommandBuffer()
    }
    
    public static func beginRenderPass(type: RenderPassType, target: RenderPassTarget) {
        rendererAPI?.beginRenderPass(type: type, target: target)
    }
    
    public static func render(/*renderable*/) {
        rendererAPI?.render()
    }
    
    public static func endRenderPass() {
        rendererAPI?.endRenderPass()
    }
    
    public static func submitCommandBuffer() {
        rendererAPI?.submitCommandBuffer()
    }
}
