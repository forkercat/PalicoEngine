//
//  File.swift
//  
//
//  Created by Junhao Wang on 12/16/21.
//

import Palico

class EditorApp: Application {
    override init(name: String = "Palico Editor", arguments: [String] = []) {
        super.init(name: name, arguments: arguments)
        pushLayer(EditorLayer())
    }
}
