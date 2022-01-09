//
//  Component+Camera.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

import Foundation

public class CameraComponent: Component {
    public var uuid: String = UUID().uuidString
    public var title: String { "Camera" }
    // TODO: SceneCamera
    
    public var gameObject: GameObject { MothECS.getGameObject(self) }
}

// Equatable/Hashable
extension CameraComponent {
    public static func == (lhs: CameraComponent, rhs: CameraComponent) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension CameraComponent {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
