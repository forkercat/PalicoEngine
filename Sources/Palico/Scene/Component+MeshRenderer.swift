//
//  Component+MeshRenderer.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

public class MeshRendererComponent: Component {
    public var title: String { "Mesh Renderer" }
    public var enabled: Bool = true
    public static var icon: String { FAIcon.vectorSquare }
    
    // Mesh
    public private(set) var mesh: Mesh? = nil
    public private(set) var meshType: PrimitiveType? = nil  // TODO: Should be dedicated MeshType instead of PrimitiveTypes
    
    // Material
    public var tintColor: Color4 = .white
    
    public required init() { }
    
    public func setMesh(_ primitiveType: PrimitiveType?) {
        meshType = primitiveType
        
        guard let primitiveType = primitiveType else {
            mesh = nil
            return
        }
        
        switch primitiveType {
        case .cube:
            mesh = MeshFactory.makePrimitiveMesh(type: .cube)
        case .sphere:
            mesh = MeshFactory.makePrimitiveMesh(type: .sphere)
        case .hemisphere:
            mesh = MeshFactory.makePrimitiveMesh(type: .hemisphere)
        case .plane:
            mesh = MeshFactory.makePrimitiveMesh(type: .plane)
        case .capsule:
            mesh = MeshFactory.makePrimitiveMesh(type: .capsule)
        case .cylinder:
            mesh = MeshFactory.makePrimitiveMesh(type: .cylinder)
        case .cone:
            mesh = MeshFactory.makePrimitiveMesh(type: .cone)
        }
    }
}
