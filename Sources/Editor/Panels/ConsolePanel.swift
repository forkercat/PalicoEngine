//
//  ConsolePanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class ConsolePanel: Panel {
    var panelName: String { "Console" }
    
    func onImGuiRender() {
        ImGuiBegin(panelName, nil, 0)
        
        
        
        ImGuiEnd()
    }
}
