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
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(2, 2))
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(3, 6))
        
        ImGuiTextV("\(FAIcon.star) Favorite")
        if ImGuiTreeNode("\(FAIcon.folder) IT IS FAKE!") { ImGuiTreePop() }
        
        ImGuiSeparator()
        
        ImGuiTextV("\(FAIcon.cloud) Cloud")
        if ImGuiTreeNode("\(FAIcon.folder) IT IS FAKE!") { ImGuiTreePop() }
        
        ImGuiSeparator()
        
        ImGuiTextV("\(FAIcon.archive) Assets")
        
        if ImGuiTreeNode("\(FAIcon.folder) IT IS FAKE!") { ImGuiTreePop() }
        if ImGuiTreeNode("\(FAIcon.folder) Fonts") { ImGuiTreePop() }
        if ImGuiTreeNode("\(FAIcon.folder) Materials") {
            if ImGuiTreeNode("\(FAIcon.folder) Shaders") {
                ImGuiIndent(16)
                ImGuiTextV("\(FAIcon.fileCode) Main.metal")
                ImGuiTextV("\(FAIcon.fileCode) Shadow.metal")
                ImGuiUnindent(16)
                ImGuiTreePop()
            }
            if ImGuiTreeNode("\(FAIcon.folder) Textures") { ImGuiTreePop() }
            ImGuiTreePop()
        }
        if ImGuiTreeNode("\(FAIcon.folder) Models") {
            ImGuiTreePop()
        }
        if ImGuiTreeNode("\(FAIcon.folder) Scenes") {
            ImGuiTreePop()
        }
        if ImGuiTreeNode("\(FAIcon.folder) Sounds") {
            if ImGuiTreeNode("\(FAIcon.folder) BGM") { ImGuiTreePop() }
            if ImGuiTreeNode("\(FAIcon.folder) SFX") { ImGuiTreePop() }
            ImGuiTreePop()
        }
        if ImGuiTreeNode("\(FAIcon.folder) Scripts") {
            if ImGuiTreeNode("\(FAIcon.folder) Controllers") { ImGuiTreePop() }
            if ImGuiTreeNode("\(FAIcon.folder) Managers") { ImGuiTreePop() }
            if ImGuiTreeNode("\(FAIcon.folder) Player") { ImGuiTreePop() }
            ImGuiTreePop()
        }
        
        ImGuiPopStyleVar(2)
        
        ImGuiEnd()
    }
}
