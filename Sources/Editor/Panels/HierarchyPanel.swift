//
//  HierarchyPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class HierarchyPanel: Panel {
//    var panelName: String { "\(FAIcon.sitemap) Scene Hierarchy" }
    var panelName: String { "Scene Hierarchy" }
    
    func onImGuiRender() {
        ImGuiBegin("\(FAIcon.list) \(panelName)", nil, 0)
        
        
        
        ImGuiEnd()
    }
}

class InspectorPanel: Panel {
    var panelName: String { "Inspector" }
    
    func onImGuiRender() {
        ImGuiBegin("\(FAIcon.palette) \(panelName)", nil, 0)
        
        
        
        ImGuiEnd()
    }
}







