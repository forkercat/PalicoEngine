//
//  Shader.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

import Foundation

public protocol Shader {
    var name: String { get }
    var filepath: String { get }
    var source: String? { get }
    var isCompiled: Bool { get set }
    
    init(name: String, url: URL)
    init(name: String, source: String)
}
