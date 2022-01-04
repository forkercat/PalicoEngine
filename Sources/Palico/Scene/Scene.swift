//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

class Scene {
    var viewportWidth: UInt32 = 0
    var viewportHeight: UInt32 = 0
    
    var gameObjects: [GameObject] = []
    
    func onUpdateRuntime(deltaTime: Timestep) {
        
    }
    
    func onUpdateEditor(deltaTime: Timestep) {
        
    }
    
    func onViewportResize(width: UInt32, height: UInt32) {
        
    }
}


// GameObject
extension Scene {
    func createGameObject() {
        
    }
    
    func destroyGameObject() {
        
    }
}

// Component Event Callbacks
extension Scene {
    
}
