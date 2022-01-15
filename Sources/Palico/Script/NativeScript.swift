//
//  NativeScript.swift
//  Palico
//
//  Created by Junhao Wang on 1/15/22.
//

import MothECS

open class NativeScript {
    open var name: String
    
    weak var gameObject: GameObject! = nil
    
    public var entityID: MothEntityID {
        assert(gameObject != nil, "Native script has nil game object!")
        return gameObject!.entityID
    }
    
    public var gameObjectName: String {
        assert(gameObject != nil, "Native script has nil game object!")
        return gameObject!.name
    }
    
    public init(name: String = "Unnamed Script") {
        self.name = name
    }
    
    public func getGameObject() -> GameObject {
        assert(gameObject != nil, "Native script has nil game object!")
        return gameObject!
    }
    
    public func hasComponent<T: Component>(_ type: T.Type) -> Bool {
        assert(gameObject != nil, "Native script has nil game object!")
        return gameObject.hasComponent(type)
    }
    
    public func getComponent<T: Component>(_ type: T.Type) -> T {
        assert(gameObject != nil, "Native script has nil game object!")
        return gameObject.getComponent(type)
    }
    
    // Overridden by users
    open func onCreate() {
        
    }
    
    open func onDestroy() {
        
    }
    
    open func onUpdate(deltaTime ts: Timestep) {
        
    }
    
    open func onUpdateEditor(deltaTime ts: Timestep) {
        
    }
}
