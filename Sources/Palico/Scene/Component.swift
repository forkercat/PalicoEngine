//
//  Component.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MathLib
import MothECS

public protocol Component: MothComponent {
    var title: String { get }
}

//public protocol Component: AnyObject {
//    var uuid: String { get }
//    var title: String { get }
//    var gameObject: GameObject { get }
//}
