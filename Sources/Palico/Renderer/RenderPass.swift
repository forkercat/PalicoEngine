//
//  RenderPass.swift
//  Palico
//
//  Created by Junhao Wang on 12/27/21.
//

import MetalKit

public enum RenderPassBeginAction {
    case clear
    case keep
    case dontCare
}

public enum RenderPassEndAction {
    case store
    case dontCare
}

func convertMTLLoadAction(_ action: RenderPassBeginAction) -> MTLLoadAction {
    switch action {
    case .clear:
        return .clear
    case .keep:
        return .load
    case .dontCare:
        return .dontCare
    }
}

func convertMTLStoreAction(_ action: RenderPassEndAction) -> MTLStoreAction {
    switch action {
    case .store:
        return .store
    case .dontCare:
        return .dontCare
    }
}

class RenderPass {
    enum TextureType {
        case color
        case depth
        case normal
        case position
        // ...
    }
    
    var descriptor: MTLRenderPassDescriptor = MTLRenderPassDescriptor()
    var textures: [TextureType: MTLTexture] = [:]
    
    let name: String
    
    init(name: String, size: CGSize) {
        self.name = name
        textures[.color] = buildColorTexture(size: size)
        textures[.depth] = buildDepthTexture(size: size)
    }
    
    func addNormalTexture(size: CGSize) {
        textures[.normal] = buildNormalTexture(size: size)
    }
    
    func addPositionTexture(size: CGSize) {
        textures[.position] = buildPositionTexture(size: size)
    }
    
    func updateTextures(size: CGSize) {
        guard size.width != 0 && size.height != 0 else {
            return
        }
        
        if textures[.color] != nil {
            textures[.color] = buildColorTexture(size: size)
        }
        if textures[.depth] != nil {
            textures[.depth] = buildDepthTexture(size: size)
        }
        if textures[.normal] != nil {
            textures[.normal] = buildNormalTexture(size: size)
        }
        if textures[.position] != nil {
            textures[.position] = buildPositionTexture(size: size)
        }
        descriptor = setupRenderPassDescriptor()
    }
    
    private func setupRenderPassDescriptor() -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        if let colorTexture = textures[.color] {
            descriptor.setUpColorAttachment(position: 0, texture: colorTexture)
        }
        if let depthTexture = textures[.depth] {
            descriptor.setUpDepthAttachment(texture: depthTexture)
        }
        return descriptor
    }
    
    private func buildColorTexture(size: CGSize) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_color",
                                         pixelFormat: .bgra8Unorm,
                                         usage: [.renderTarget, .shaderRead])
    }
    
    private func buildDepthTexture(size: CGSize) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_depth",
                                         pixelFormat: .depth32Float,
                                         usage: [.renderTarget, .shaderRead])
    }
    
    private func buildNormalTexture(size: CGSize) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_normal",
                                         pixelFormat: .bgra8Unorm,
                                         usage: [.renderTarget, .shaderRead])
    }
    
    private func buildPositionTexture(size: CGSize) -> MTLTexture {
        return TextureUtils.buildTexture(size: size, label: name + "_position",
                                         pixelFormat: .bgra8Unorm,
                                         usage: [.renderTarget, .shaderRead])
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
