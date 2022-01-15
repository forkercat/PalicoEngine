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
    var gameObjectMap: [MothEntityID: GameObject] = [:]
    var viewportSize: Int2 = [0, 0]
    
    public var gameObjectList: [GameObject] { get {
        var list: [GameObject] = []
        for entityID in moth.entityIDs {
            list.append(gameObjectMap[entityID]!)
        }
        return list
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
        for gameObject in gameObjectMap.values {
            gameObject.onUpdateRuntime(deltaTime: ts)
        }
    }
    
    public func onRenderRuntime(deltaTime ts: Timestep) {
        // TODO: Play Mode
    }
    
    public func onViewportResize(size: Int2) {
        viewportSize = size
        // TODO: Resize scene camera. Needed?
    }
}
