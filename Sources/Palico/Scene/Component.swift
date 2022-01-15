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
    var enabled: Bool { get set }
    static var icon: String { get }
}
