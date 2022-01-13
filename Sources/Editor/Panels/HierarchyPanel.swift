//
//  HierarchyPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class HierarchyPanel: Panel {
    var panelName: String { "Scene Hierarchy" }
    
    var scene: Scene = Scene()
    
    func onUpdate(deltaTime ts: Timestep) {
        scene.onUpdateEditor(deltaTime: ts)
    }
    
    func onImGuiRender() {
        ImGuiBegin("\(FAIcon.list) \(panelName)", nil, 0)
        
        let flags: ImGuiTreeNodeFlags = Im(ImGuiTreeNodeFlags_SpanAvailWidth)
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(8, 8))
        
        let gameObjectList = scene.gameObjectList
        for gameObject in gameObjectList {
            let opened: Bool = ImGuiTreeNodeEx("\(gameObject.name)  - EntityID: \(gameObject.entityID)", flags)
            
            if opened {
                ImGuiTextV("EntityID: \(gameObject.entityID)")
                ImGuiTreePop()
            }
        }
        
        ImGuiPopStyleVar(1)
        
        ImGuiEnd()
    }
}
