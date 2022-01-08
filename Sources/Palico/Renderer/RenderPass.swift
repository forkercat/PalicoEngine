//
//  RenderPass.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import MetalKit
import MathLib

public class RenderPass {    
    public struct Target: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) { self.rawValue = rawValue }
        
        public static let color       = Self(rawValue: 1 << 0)
        public static let depth       = Self(rawValue: 1 << 1)
        public static let normal      = Self(rawValue: 1 << 2)
        public static let position    = Self(rawValue: 1 << 3)
        // ...
    }
    
    var descriptor: MTLRenderPassDescriptor? = nil
    
    public var colorTexture: MTLTexture? = nil
    public var depthTexture: MTLTexture? = nil
    public var normalTexture: MTLTexture? = nil
    public var positionTexture: MTLTexture? = nil
    
    public private(set) var size: Int2 = [1, 1]
    
    public let name: String
    
    init(name: String, size: Int2, targets: Target = [.color, .depth]) {
        guard size.width > 0 && size.height > 0 else {
            fatalError("Do not initialize render pass with zero width or height!")
        }
        
        self.name = name
        self.size = size
        
        if targets.contains(.color) {
            colorTexture = buildColorTexture(size: size)
        }
        
        if targets.contains(.depth) {
            depthTexture = buildDepthTexture(size: size)
        }
        
        if targets.contains(.normal) {
            normalTexture = buildNormalTexture(size: size)
        }
        
        if targets.contains(.position) {
            positionTexture = buildPositionTexture(size: size)
        }
        
        descriptor = setupRenderPassDescriptor()
    }
    
    func resizeTextures(size: Int2, targets: Target = [.color, .depth, .normal, .position]) {
        guard size.width > 0 && size.height > 0 else {
            Log.warn("You are resizing textures in render pass with zero width or height. Skipping resize!")
            return
        }
        
        self.size = size
        
        if targets.contains(.color) && colorTexture != nil {
            colorTexture = buildColorTexture(size: size)
        }
        
        if targets.contains(.depth) && depthTexture != nil {
            depthTexture = buildDepthTexture(size: size)
        }
        
        if targets.contains(.normal) && normalTexture != nil {
            normalTexture = buildNormalTexture(size: size)
        }
        
        if targets.contains(.position) && positionTexture != nil {
            positionTexture = buildPositionTexture(size: size)
        }
        
        descriptor = setupRenderPassDescriptor()
    }
    
    private func setupRenderPassDescriptor() -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        
        if let texture = colorTexture {
            descriptor.setUpColorAttachment(position: 0, texture: texture)
        }
        
        if let texture = depthTexture {
            descriptor.setUpDepthAttachment(texture: texture)
        }
        
        // TODO: set up normal, position textures
        
        return descriptor
    }
    
    private func buildColorTexture(size: Int2) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_color",
                                         pixelFormat: RenderConfig.PixelFormat.color,
                                         usage: [.renderTarget, .shaderRead],
                                         storage: .private)
    }
    
    private func buildDepthTexture(size: Int2) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_depth",
                                         pixelFormat: RenderConfig.PixelFormat.depth,
                                         usage: [.renderTarget, .shaderRead],
                                         storage: .private)
    }
    
    private func buildNormalTexture(size: Int2) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_normal",
                                         pixelFormat: RenderConfig.PixelFormat.normal,
                                         usage: [.renderTarget, .shaderRead],
                                         storage: .private)
    }
    
    private func buildPositionTexture(size: Int2) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_position",
                                         pixelFormat: RenderConfig.PixelFormat.position,
                                         usage: [.renderTarget, .shaderRead],
                                         storage: .private)
    }
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
        attachment.clearColor = MTLClearColorMake(0, 0, 0, 1)
    }
}
