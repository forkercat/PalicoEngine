//
//  RendererAPI.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

protocol RendererAPIImplDelegate {
    func initialize()
    func makeCommandBuffer()
    func beginRenderPass(type: RenderPassType, target: RenderPassTarget)
    func endRenderPass()
    func render()
    func submitCommandBuffer()
}

public struct RendererAPI {
    public enum API {
        case none
        case metal
        case openGL
        case vulkan
    }
    
    private(set) static var api: API = .metal
    
    private init() { }
    
    public static func getAPI() -> API {
        return Self.api
    }
    
    internal static func create() -> RendererAPIImplDelegate {
        switch api {
        case .metal:
            return MetalRendererAPI()
        default:
            fatalError("API \(api) is not supported!")
        }
    }
}
