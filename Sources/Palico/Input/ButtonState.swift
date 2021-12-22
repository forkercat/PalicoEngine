//
//  ButtonState.swift
//  
//
//  Created by Junhao Wang on 12/20/21.
//

public typealias State = UInt16

public enum ButtonState: State {
    // From glfw3.h
    case released = 0
    case pressed  = 1
    case repeated = 2
    
    case unknown  = 10
}
