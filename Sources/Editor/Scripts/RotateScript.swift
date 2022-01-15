//
//  RotateScript.swift
//  Editor
//
//  Created by Junhao Wang on 1/15/22.
//

import Palico

class RotateScript: NativeScript {
    var rotateSpeed: Float = 0.5
    
    override init(name: String = "RotateScript") {
        super.init(name: name)
    }
    
    init(name: String = "RotateScript", speed: Float) {
        rotateSpeed = speed
        super.init(name: name)
    }
    
    override func onCreate() {
        Console.info("[\(name)] Called onCreate() in native script on \(gameObjectName) [EntityID: \(entityID)]")
    }
    
    override func onUpdate(deltaTime ts: Timestep) {
        
    }
    
    override func onUpdateEditor(deltaTime ts: Timestep) {
        let transform = getComponent(TransformComponent.self)
        transform.rotation.y += rotateSpeed * Time.deltaTime  // or you can use ts
//        transform.rotation.y = y.truncatingRemainder(dividingBy: 360.0)
        
    }
}
