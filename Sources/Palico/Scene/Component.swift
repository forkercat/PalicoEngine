//
//  Component.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MathLib
import MetalKit

public protocol Component: AnyObject {
    var uuid: String { get }
    var title: String { get }
    var gameObject: GameObject { get }
}
