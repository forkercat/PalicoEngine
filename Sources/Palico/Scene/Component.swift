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
    static var icon: String { get }
}
