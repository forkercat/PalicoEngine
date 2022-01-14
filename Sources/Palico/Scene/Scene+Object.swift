//
//  Scene+Object.swift
//  Palico
//
//  Created by Junhao Wang on 1/13/22.
//

import MothECS

extension Scene {
    // Create
    @discardableResult
    public func createEmptyGameObject() -> GameObject {
        let gameObject = GameObject(self)
        gameObjectMap[gameObject.entityID] = gameObject
        return gameObject
    }
    
    @discardableResult
    public func createPrimitive(type: PrimitiveType) -> Primitive {
        switch type {
        case .cube:
            let gameObject = Cube(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .sphere:
            let gameObject = Sphere(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .hemisphere:
            let gameObject = Hemisphere(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .plane:
            let gameObject = Plane(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .capsule:
            let gameObject = Capsule(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .cylinder:
            let gameObject = Cylinder(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .cone:
            let gameObject = Cone(self)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        }
    }
    
    @discardableResult
    public func createSceneLight(type: LightType) -> SceneLight {
        switch type {
        case .dirLight:
            let gameObject = SceneLight(self, name: "Directional Light", type: .dirLight)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .pointLight:
            let gameObject = SceneLight(self, name: "Point Light", type: .pointLight)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .spotLight:
            let gameObject = SceneLight(self, name: "Spot Light", type: .spotLight)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        case .ambientLight:
            let gameObject = SceneLight(self, name: "Ambient Light", type: .ambientLight)
            gameObjectMap[gameObject.entityID] = gameObject
            return gameObject
        }
    }
    
    // Add
    public func addGameObject(_ gameObject: GameObject) {
        gameObjectMap[gameObject.entityID] = gameObject
    }
    
    public func addGameObjects(_ gameObjects: [GameObject]) {
        for gameObject in gameObjects {
            addGameObject(gameObject)
        }
    }
    
    // Get
    public func getGameObjectBy(entityID: MothEntityID) -> GameObject {
        return gameObjectMap[entityID]!
    }
    
    // Destroy
    @discardableResult
    public func destroyGameObject(_ gameObject: GameObject) -> Bool {
        let result: Bool = moth.removeEntity(entityID: gameObject.entityID)
        if result {
            gameObjectMap[gameObject.entityID] = nil
        }
        return result
    }
}
