//
//  GameObject.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib
import MothECS

public class GameObject {
    public var name: String = "GameObject"
    public var enabled: Bool = true
    
    public let entityID: MothEntityID
    
    internal weak var scene: Scene! = nil
        
    init(_ scene: Scene,
         name: String = "GameObject",
         position: Float3 = [0, 0, 0],
         rotation: Float3 = [0, 0, 0],
         scale: Float3 = [1, 1, 1]) {

        self.scene = scene
        self.name = name
        entityID = scene.moth.createEntity()
                
        let transform = TransformComponent()
        transform.position = position
        transform.rotation = rotation
        transform.scale = scale
        let tag = TagComponent()
        
        addComponent(tag)
        addComponent(transform)
    }
    
    // Editor Update
    public func onUpdateEditor(deltaTime ts: Timestep) {
        
    }
    
    // Runtime Update
    public func onUpdateRuntime(deltaTime ts: Timestep) {
        // TODO: Play Mode
        // Update script component as well
    }
}

extension GameObject: Equatable {
    public static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.entityID == rhs.entityID
    }
}

extension GameObject: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(entityID)
    }
}

// Component Methods
extension GameObject {
    public func addComponent<T: Component>(_ component: T) {
        scene.moth.assignComponent(component, to: entityID)
    }
    
    public func addComponent<T: Component>(_ type: T.Type) {
        scene.moth.createComponent(type, to: entityID)
    }
    
    public func hasComponent<T: Component>(_ type: T.Type) -> Bool {
        return scene.moth.hasComponent(type, in: entityID)
    }
    
    public func getComponent<T: Component>(_ type: T.Type) -> T {
        return scene.moth.getComponent(type, from: entityID)
    }
    
    @discardableResult
    public func removeComponent<T: Component>(_ component: T) -> T? {
        guard !(component is TagComponent) || !(component is TransformComponent) else {
            Console.warn("\(T.self) cannot be removed from a game object!")
            return nil
        }
        return scene.moth.removeComponent(T.self, from: entityID)
    }
    
    @discardableResult
    public func removeComponent<T: Component>(_ type: T.Type) -> T? {
        guard type != TagComponent.self && type != TransformComponent.self else {
            Console.warn("\(T.self) cannot be removed from a game object!")
            return nil
        }
        return scene.moth.removeComponent(T.self, from: entityID)
    }
}
