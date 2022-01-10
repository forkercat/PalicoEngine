//
//  GameObject.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib
import Foundation

open class GameObject {
    public let uuid: String = UUID().uuidString
    
    public var name: String = "Unnamed GameObject"
    
    internal var components: [Component] = []  // internally used in ECS
    
    public init(name: String = "Unnamed GameObject",
                position: Float3 = [0, 0, 0],
                rotation: Float3 = [0, 0, 0],
                scale: Float3 = [1, 1, 1]) {
        self.name = name
        
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
