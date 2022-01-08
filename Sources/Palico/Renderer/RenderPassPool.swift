//
//  RenderPassPool.swift
//  Palico
//
//  Created by Junhao Wang on 1/3/22.
//

import Metal
import MathLib

public enum RenderPassType {
    case colorPass
    case shadowPass
    case geometryPass
}

class RenderPassPool {
    static var shared: RenderPassPool = RenderPassPool()
    
    private let colorPass: RenderPass
    private let shadowPass: RenderPass
    private let geometryPass: RenderPass
    
    private init(size: Int2 = [1, 1]) {
        colorPass = RenderPass(name: "ColorPass", size: size, targets: [.color, .depth])
        shadowPass = RenderPass(name: "ShadowPass", size: size, targets: [.depth])
        geometryPass = RenderPass(name: "GeometryPass", size: size, targets: [.normal, .position])
    }
    
    /*
    func resizeAllRenderPasses(size: Int2) {
        colorPass.resizeTextures(size: size)
        shadowPass.resizeTextures(size: size)
        geometryPass.resizeTextures(size: size)
    }
     */
    
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
