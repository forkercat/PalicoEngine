//
//  GameObject.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

open class GameObject {
    public var name: String = "Unnamed GameObject"
    
    private var components: [Component] = []
    
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
    
    public func onUpdate(deltaTime ts: Timestep) {
        
    }
}

// Component Methods
extension GameObject {
    public func addComponent(_ component: Component) {
        components.append(component)
    }
    
    public func getComponent(at index: Int) -> Component {
        assert(index >= 0 && index < components.count, "Component index out of bound!")
        return components[index]
    }
    
    public func removeComponent() {
        
    }
    
    public func hasComponent() -> Bool {
        return false
    }
}
