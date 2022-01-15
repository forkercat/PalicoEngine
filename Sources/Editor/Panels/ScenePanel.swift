//
//  ScenePanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui
import MothECS

class ScenePanel: Panel {
    var panelName: String { "No Name" }  // This panel contains two sub-panels
    var hierarchyPanelName: String { "Scene Hierarchy" }
    var inspectorPanelName: String { "Inspector" }
    
    var debugCursor: Int = -1
    
    var scene: Scene = Scene()
    var selectedEntityID: MothEntityID = .invalid
    
    func onUpdate(deltaTime ts: Timestep) {
        scene.onUpdateEditor(deltaTime: ts)
    }
    
    func onImGuiRender() {
        drawHierarchyPanel()
        drawInspectorPanel()
    }
}
