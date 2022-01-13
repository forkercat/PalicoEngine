//
//  InspectorPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class InspectorPanel: Panel {
    var panelName: String { "Inspector" }
    
    func onImGuiRender() {
        ImGuiBegin("\(FAIcon.palette) \(panelName)", nil, 0)
        
        
        
        ImGuiEnd()
    }
}
