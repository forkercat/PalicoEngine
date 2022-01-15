//
//  Editor.swift
//  Editor
//
//  Created by Junhao Wang on 12/16/21.
//

import Palico
import MathLib

class Editor: Application {
    override init(name: String = "Palico Editor", arguments: [String] = [], size: Int2 = [1280, 720]) {
        super.init(name: name, arguments: arguments, size: size)
        
        let editorLayer = EditorLayer(name: "Editor Layer")
        pushLayer(editorLayer)
        
        editorLayer.showDebugScene()
    }
}
