//
//  MyScript.swift
//  Editor
//
//  Created by Junhao Wang on 1/15/22.
//

import Palico

class MyScript: NativeScript {
    override init(name: String = "MyScript") {
        super.init(name: name)
    }
    
    override func onCreate() {
        Console.info("[\(name)] Calling onCreate() on native script in \(gameObjectName) [EntityID: \(entityID)]")
    }
    
    override func onUpdate(deltaTime ts: Timestep) {
        
    }
    
    override func onUpdateEditor(deltaTime ts: Timestep) {
        
    }
}
