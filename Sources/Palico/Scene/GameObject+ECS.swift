//
//  GameObject+ECS.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

// Equatable/Hashable
extension GameObject: Equatable {
    public static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension GameObject: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

// Component Methods
extension GameObject {
    public func addComponent<T: Component>(_ component: T) {
        MothECS.addComponent(self, component)
    }
    
    public func getComponent<T: Component>() -> T? {
        return MothECS.getComponent(self)
    }
    
    public func removeComponent<T: Component>(_ component: T) -> Bool {
        guard !(component is TagComponent) || !(component is TransformComponent) else {
            Console.warn("Component (\(component.title) cannot be removed from a game object!")
            return false
        }
        
        return MothECS.removeComponent(self, component)
    }
    
    public func hasComponent<T: Component>(_ type: T.Type) -> Bool {
        return MothECS.hasComponent(self, type)
    }
}
