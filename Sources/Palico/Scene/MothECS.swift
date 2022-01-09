//
//  ForkerECS.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

// Entity-Component System (trivial version ><)
// Internal Usage in Palico (Editor has no idea what it is!)
enum ForkerECS {
    private static var componentGameObjectMap: [String: GameObject] = [:]  // UUID -> GameObject
}

// Scene Methods
extension ForkerECS {
    static func getComponentList<T: Component>(_ scene: Scene) -> [T] {
        var result: [T] = []
        
        for gameObject in scene.gameObjects {
            if let component: T = gameObject.getComponent() {  // inside it has hasComponent check
                result.append(component)
            }
        }
        return result
    }
}

// Component Methods
extension ForkerECS {
    static func getGameObject(_ component: Component) -> GameObject {
        guard let gameObject = componentGameObjectMap[component.uuid] else {
            fatalError("This component \(component) does not belong to any GameObject!")
        }
        return gameObject
    }
}

// GameObject Methods
extension ForkerECS {
    static func addComponent<T: Component>(_ gameObject: GameObject, _ component: T) {
        guard !Self.hasComponent(gameObject, T.self) else {
            Log.error("The component type (\(T.self)) already exists. Only one type of component is allowed!")
            assertionFailure()
            return
        }
        gameObject.components.append(component)
        Self.componentGameObjectMap[component.uuid] = gameObject
    }
    
    static func getComponent<T: Component>(_ gameObject: GameObject) -> T? {
        guard let index = gameObject.components.firstIndex(where: { $0 is T }) else {
            return nil
        }
        return gameObject.components[index] as? T
    }
    
    static func removeComponent<T: Component>(_ gameObject: GameObject, _ component: T) -> Bool {
        guard let index = gameObject.components.firstIndex(where: { $0.uuid == component.uuid }) else {
            return false
        }
        gameObject.components.remove(at: index)
        Self.componentGameObjectMap.removeValue(forKey: component.uuid)
        return true
    }
    
    static func hasComponent<T: Component>(_ gameObject: GameObject, _ type: T.Type) -> Bool {
        let result = gameObject.components.contains(where: { $0 is T })
        return result
    }
}
