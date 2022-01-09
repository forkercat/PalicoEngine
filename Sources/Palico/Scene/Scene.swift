//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

public class Scene {
    public private(set) var gameObjects: [GameObject] = []
    public var bgColor: Color = .black
    
    private var viewportSize: Int2 = [0, 0]
    
    // Testing
    // TODO: Remove after using ECS!
    let cube = Cube(name: "Cube", position: [0, 0, 0])
    let sphere = Sphere(name: "Sphere",
                        position: [4, 3, 20],
                        rotation: [0, 0, 0],
                        scale: [0.5, 0.5, 0.5])
    let lights: [SceneLight] = [SceneLight(name: "DirLight", type: .dirLight),
                                SceneLight(name: "PointLight", type: .pointLight)]
    
    public init() {
        bgColor = Color(r: 0.1, g: 0.1, b: 0.1, a: 1.0)
    }
}

// Update
extension Scene {
    public func onUpdateEditor(deltaTime ts: Timestep, editorCamera: EditorCamera) {
        Renderer.beginRenderPass(type: .colorPass, begin: .clear,
                                 clearColor: bgColor)
        
        // Setup
        Renderer.preRenderSetup(scene: self, camera: editorCamera)
        
        // Renderer.render(scene: self)
        
        Renderer.render(gameObject: cube)
        Renderer.render(gameObject: sphere)
        
        Renderer.endRenderPass()
    }
    
    public func onUpdateRuntime(deltaTime ts: Timestep) {
        
        
        
    }
    
    public func onViewportResize(size: Int2) {
        viewportSize = size
        
        // TODO: Resize scene cameras
    }
}

// GameObject
extension Scene {
    public func createGameObject() {
        
    }
    
    public func destroyGameObject() {
        
    }
}

// Component Event Callbacks
extension Scene {
    
}
