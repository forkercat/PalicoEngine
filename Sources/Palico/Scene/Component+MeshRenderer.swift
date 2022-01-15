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
    public var mesh: Mesh? = nil
    
    // Material
    public var tintColor: Color4 = .white
    
    public required init() {
        
    }
    
    init(mesh: Mesh) {
        self.mesh = mesh
        self.tintColor = .white
    }
}
