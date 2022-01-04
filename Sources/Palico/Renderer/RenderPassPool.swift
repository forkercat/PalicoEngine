//
//  RenderPassPool.swift
//  Palico
//
//  Created by Junhao Wang on 1/3/22.
//

import Foundation

public enum RenderPassType {
    case colorPass
    case shadowPass
    case geometryPass
}

class RenderPassPool {
    private(set) static var shared: RenderPassPool = RenderPassPool()
    
    private let colorPass: RenderPass
    private let shadowPass: RenderPass
    private let geometryPass: RenderPass
    
    private init(size: CGSize = CGSize(width: 1, height: 1)) {
        colorPass = RenderPass(name: "ColorPass", size: size)
        shadowPass = RenderPass(name: "ShadowPass", size: size)
        geometryPass = RenderPass(name: "GeometryPass", size: size)
        geometryPass.addNormalTexture(size: size)
        geometryPass.addPositionTexture(size: size)
    }
    
    func updateAllTextureSizes(size: CGSize) {
        colorPass.updateTextures(size: size)
        shadowPass.updateTextures(size: size)
        geometryPass.updateTextures(size: size)
    }
    
    func fetchRenderPass(type: RenderPassType) -> RenderPass {
        switch type {
        case .colorPass:
            return colorPass
        case .shadowPass:
            return shadowPass
        case .geometryPass:
            return geometryPass
        }
    }
}
