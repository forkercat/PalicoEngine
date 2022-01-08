//
//  GameObject.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

open class GameObject {
    var name: String = "Unnamed GameObject"
    
    var components: [Component] = []
    
    
    
    init(name: String = "Unnamed GameObject",
         position: Float3 = [0, 0, 0],
         rotation: Float3 = [0, 0, 0],
         scale: Float3 = [1, 1, 1]) {
        self.name = name
        
        let transform = TransformComponent()
        transform.position = position
        
        let tag = TagComponent()
        
        addComponent(transform)
        addComponent(tag)
    }
    
}

//
extension GameObject {
    
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

public protocol Primitive {
    
}

public class Cube: GameObject, Primitive {
    public override init(name: String = "Cube",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .cube)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

public class Sphere: GameObject, Primitive {
    public override init(name: String = "Sphere",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .sphere)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

//public class Triangle: GameObject, Primitive {
//    public override init(name: String = "Triangle", position: Float3 = [0, 0, 0]) {
//        super.init(name: name, position: position)
//
//        let mesh = MeshFactory.getPrimitiveMesh(type: .triangle)
//        addComponent(MeshRendererComponent(mesh: mesh))
//    }
//}

public class Plane: GameObject, Primitive {
    public override init(name: String = "Plane",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .plane)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}
