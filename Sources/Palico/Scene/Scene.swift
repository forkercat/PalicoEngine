//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

public class Scene {
    public var bgColor: Color = .black
    
    internal var gameObjects: [GameObject] = []
    private var viewportSize: Int2 = [0, 0]
    
    // Testing
    // TODO: Remove after using ECS!
    
    public init() {
        bgColor = Color(r: 0.13, g: 0.13, b: 0.13, a: 1.0)
    }
}

// Update
extension Scene {
    // Editor
    public func onUpdateEditor(deltaTime ts: Timestep) {
        for gameObject in gameObjects {
            gameObject.onUpdateEditor(deltaTime: ts)
        }
    }
    
    public func onRenderEditor(deltaTime ts: Timestep, editorCamera: EditorCamera) {
        Renderer.beginRenderPass(type: .colorPass,
                                 begin: .clear,
                                 clearColor: bgColor)
        // Setup
        Renderer.preRenderSetup(scene: self, camera: editorCamera)
        
        Renderer.render(scene: self)
        
        Renderer.endRenderPass()
    }
    
    // Runtime
    public func onUpdateRuntime(deltaTime ts: Timestep) {
        // TODO: Play Mode
    }
    
    public func onRenderRuntime(deltaTime ts: Timestep) {
        // TODO: Play Mode
    }
    
    public func onViewportResize(size: Int2) {
        viewportSize = size
        // TODO: Resize scene camera. Needed?
    }
}

// GameObject
extension Scene {
    // Create and destroy methods
    public func addGameObject(_ gameObject: GameObject) {
        self.gameObjects.append(gameObject)
    }
    
    public func addGameObjects(_ gameObjects: [GameObject]) {
        self.gameObjects.append(contentsOf: gameObjects)
    }
    
    public func destroyGameObject(_ gameObject: GameObject) {
        // TODO: use ECS
    }
}

// Component Event Callbacks
extension Scene {
    
}
