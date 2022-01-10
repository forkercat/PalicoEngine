//
//  Scene+ECS.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

extension Scene {
    public func getComponentList<T: Component>() -> [T] {
        return MothECS.getComponentList(self)
    }
}
