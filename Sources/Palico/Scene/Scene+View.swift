//
//  Scene+View.swift
//  Palico
//
//  Created by Junhao Wang on 1/13/22.
//

extension Scene {
    public func view<T: Component>(_ type: T.Type) -> [GameObject] {
        return moth.view(type).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component>(_ type1: T1.Type, _ type2: T2.Type)
    -> [GameObject] {
        return moth.view(type1, type2).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component, T3: Component>(_ type1: T1.Type, _ type2: T2.Type, _ type3: T3.Type)
    -> [GameObject] {
        return moth.view(type1, type2, type3).map({ gameObjectMap[$0]! })
    }
    
    // + Excepts
    public func view<T: Component>(excepts exceptType: T.Type)
    -> [GameObject] {
        return moth.view(excepts: exceptType).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component>(_ type: T1.Type, excepts exceptType: T2.Type)
    -> [GameObject] {
        return moth.view(type, type, excepts: exceptType).map({ gameObjectMap[$0]! })
    }
    
    public func view<T1: Component, T2: Component, T3: Component>(_ type1: T1.Type, _ type2: T2.Type, excepts exceptType: T3.Type)
    -> [GameObject] {
        return moth.view(type1, type2, excepts: exceptType).map({ gameObjectMap[$0]! })
    }
}
