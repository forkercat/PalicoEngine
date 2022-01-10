//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

public class Scene {
    public var bgColor: Color4 = .black
    
    // TODO: Use ECS to manage
    internal var gameObjects: [GameObject] = []
    
    public struct ObjectDebugItem {
        public let name: String
        public let uuid: String
    }
    public var debugItems: [ObjectDebugItem] = []
    
    private var viewportSize: Int2 = [0, 0]
    
    public init() {
        bgColor = Color4(r: 0.13, g: 0.13, b: 0.13, a: 1.0)
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
        self.debugItems.append(ObjectDebugItem(name: gameObject.name, uuid: gameObject.uuid))
    }
    
    public func addGameObjects(_ gameObjects: [GameObject]) {
        self.gameObjects.append(contentsOf: gameObjects)
        for gameObject in gameObjects {
            self.debugItems.append(ObjectDebugItem(name: gameObject.name, uuid: gameObject.uuid))
        }
    }
    
    public func destroyGameObject(_ gameObject: GameObject) {
        // TODO: use ECS
    }
}

// Component Event Callbacks
extension Scene {
    
}
