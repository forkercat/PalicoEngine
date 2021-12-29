//
//  Renderer.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import Foundation

public enum Renderer {
    public static func initialize() {
        RenderCommand.initialize()
    }
    
    public static func begin() {
        RenderCommand.makeCommandBuffer()
    }
    
    public static func beginRenderPass(type: RenderPassType, target: RenderPassTarget) {
        RenderCommand.beginRenderPass(type: type, target: target)
    }
    
    public static func render(/* something renderable */) {
        
    }
    
    public static func endRenderPass() {
        RenderCommand.endRenderPass()
    }
    
    public static func end() {
        RenderCommand.submitCommandBuffer()
    }
}
