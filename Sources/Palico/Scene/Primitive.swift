//
//  Primitive.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import MathLib

public protocol Primitive: AnyObject {
    
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

public class Hemisphere: GameObject, Primitive {
    public override init(name: String = "HemiSphere",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .hemiSphere)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

public class Plane: GameObject, Primitive {
    public override init(name: String = "Plane",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, Float(90.0).toRadians, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .plane)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

public class Capsule: GameObject, Primitive {
    public override init(name: String = "Plane",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .capsule)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

public class Cylinder: GameObject, Primitive {
    public override init(name: String = "Cylinder",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .cylinder)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}

public class Cone: GameObject, Primitive {
    public override init(name: String = "Plane",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [0, 0, 0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .cone)
        addComponent(MeshRendererComponent(mesh: mesh))
    }
}
