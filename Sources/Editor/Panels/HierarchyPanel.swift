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
        
    }
    
    // TODO: Remove
    func onImGuiRender(items: [Scene.ObjectDebugItem]) {
        ImGuiBegin("\(FAIcon.list) \(panelName)", nil, 0)
        
        let flags: ImGuiTreeNodeFlags = Im(ImGuiTreeNodeFlags_SpanAvailWidth)
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(8, 8))
        
        for item in items {
            let opened: Bool = ImGuiTreeNodeEx(item.name, flags)
            
            if opened {
                ImGuiTextV("uuid: \(item.uuid)")
                ImGuiTreePop()
            }
        }
        
        ImGuiPopStyleVar(1)
        
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







