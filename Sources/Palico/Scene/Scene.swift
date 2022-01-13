//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib
import MothECS

public class Scene {
    public var bgColor: Color4 = .black
    
    let moth: Moth = Moth()
    
    private var gameObjectMap: [MothEntityID: GameObject] = [:]
    private var viewportSize: Int2 = [0, 0]
    
    public var gameObjectList: [GameObject] { get {
        Array(gameObjectMap.values)
    }}
    
    public init() {
        bgColor = Color4(r: 0.13, g: 0.13, b: 0.13, a: 1.0)
    }
}

// Update
extension Scene {
    // Editor
    public func onUpdateEditor(deltaTime ts: Timestep) {
        for gameObject in gameObjectMap.values {
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

// MARK: - GameObject
extension Scene {
    // Create and destroy methods
    public func createGameObject() -> GameObject {
        let gameObject = GameObject(self)
        gameObjectMap[gameObject.entityID] = gameObject
        return gameObject
    }
    
    public func addGameObject(_ gameObject: GameObject) {
        gameObjectMap[gameObject.entityID] = gameObject
    }
    
    public func addGameObjects(_ gameObjects: [GameObject]) {
        for gameObject in gameObjects {
            addGameObject(gameObject)
        }
    }
    
    @discardableResult
    public func destroyGameObject(_ gameObject: GameObject) -> Bool {
        let result: Bool = moth.removeEntity(entityID: gameObject.entityID)
        if result {
            gameObjectMap[gameObject.entityID] = nil
        }
        return result
    }
}

// MARK: - View
extension Scene {
    public func view<T: Component>(_ type: T.Type) -> [GameObject] {
        return moth.view(type).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component>(_ type1: T1.Type, _ type2: T2.Type)
    -> [GameObject] {
        return moth.view(type1, type2).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component, T3: Component>(_ type1: T1.Type, _ type2: T2.Type, _ type3: T3.Type)
    -> [GameObject] {
        return moth.view(type1, type2, type3).map({ gameObjectMap[$0]! })
    }
    
    // + Excepts
    public func view<T: Component>(excepts exceptType: T.Type)
    -> [GameObject] {
        return moth.view(excepts: exceptType).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component>(_ type: T1.Type, excepts exceptType: T2.Type)
    -> [GameObject] {
        return moth.view(type, type, excepts: exceptType).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component, T3: Component>(_ type1: T1.Type, _ type2: T2.Type, excepts exceptType: T3.Type)
    -> [GameObject] {
        return moth.view(type1, type2, excepts: exceptType).map({ gameObjectMap[$0]! })
    }
}
