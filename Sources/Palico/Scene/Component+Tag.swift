//
//  Component+Tag.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

import Foundation

public class TagComponent: Component {
    public var uuid: String = UUID().uuidString
    public var title: String { "Tag" }
    public var gameObject: GameObject { MothECS.getGameObject(self) }
    
    public var tag: String = "Default"
}

// Equatable/Hashable
extension TagComponent {
    public static func == (lhs: TagComponent, rhs: TagComponent) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension TagComponent {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
