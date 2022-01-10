//
//  Component+MeshRenderer.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

import Foundation

public class MeshRendererComponent: Component {
    public var uuid: String = UUID().uuidString
    public var title: String { "MeshRenderer" }
    public var gameObject: GameObject { MothECS.getGameObject(self) }
    
    // Mesh
    var mesh: Mesh
    
    // Material
    public var tintColor: Color4
    
    init(mesh: Mesh) {
        self.mesh = mesh
        self.tintColor = .white
    }
}

// Equatable/Hashable
extension MeshRendererComponent {
    public static func == (lhs: MeshRendererComponent, rhs: MeshRendererComponent) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension MeshRendererComponent {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
