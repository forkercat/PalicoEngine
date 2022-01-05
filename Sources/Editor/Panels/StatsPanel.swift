//
//  StatsPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class StatsPanel: Panel {
    var panelName: String { "Stats" }
    
    func onImGuiRender() {
        let io = ImGuiGetIO()!
        
        ImGuiBegin(panelName, nil, 0)
        
        ImGuiTextV(String(format: "FPS: %.1f", io.pointee.Framerate))
        // ...
        let hoveredName = "None"
        ImGuiTextV("Hovered Game Object: \(hoveredName)")
        
        ImGuiEnd()
    }
}
