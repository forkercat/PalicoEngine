//
//  Scene.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

class Scene {
    var viewportWidth: Int = 0
    var viewportHeight: Int = 0
    
    var gameObjects: [GameObject] = []
    
    func onUpdateRuntime(deltaTime: Timestep) {
        
    }
    
    func onUpdateEditor(deltaTime: Timestep) {
        
    }
    
    func onViewportResize(width: Int, height: Int) {
        
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
