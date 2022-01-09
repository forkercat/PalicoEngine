//
//  AssetPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class AssetPanel: Panel {
    var panelName: String { "Assets" }
    
    func onImGuiRender() {
        
        ImGuiBegin("\(FAIcon.folderOpen) \(panelName)", nil, 0)
        
        ImGuiEnd()
    }
}
