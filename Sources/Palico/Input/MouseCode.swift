//
//  MouseCode.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

public typealias MouseCode = UInt16

public enum Mouse: MouseCode {
    // From glfw3.h
    case unknown = 10
    
    case button0 = 0
    case button1 = 1
    case button2 = 2
    case button3 = 3
    case button4 = 4
    case button5 = 5
    case button6 = 6
    case button7 = 7
    
    public static let buttonLast   = Self.button7
    public static let buttonLeft   = Self.button0
    public static let buttonRight  = Self.button1
    public static let buttonMiddle = Self.button2
}
