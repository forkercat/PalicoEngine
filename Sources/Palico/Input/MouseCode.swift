//
//  MouseCode.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

public typealias MouseCode = UInt16

public enum Mouse: MouseCode {
    // Currently only supports Cocoa framework
    case left    = 0
    case right   = 1
    case middle  = 2
    case button3 = 3
    case button4 = 4
    case button5 = 5
    case button6 = 6
    case button7 = 7
    
    case unknown = 9
}

extension Mouse {
    static let maxMouseCode = 10
}
