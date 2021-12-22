//
//  Time.swift
//  Palico
//
//  Created by Junhao Wang on 12/17/21.
//

import CGLFW3

public typealias Timestep = Float

extension Timestep {
    public var toMilliSeconds: Timestep {
        get { self * 1000.0 }
    }
}

public enum Time {
    public static var currentTime: Timestep {
        get { Timestep(glfwGetTime()) }
    }
}
