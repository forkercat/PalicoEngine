//
//  ImGuiDemoPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui

class ImGuiDemoPanel: Panel {
    var panelName: String { "ImGui Demo" }
    
    var open: Bool = true
//    var open: Bool = false
    
    func onImGuiRender() {
        if open {
            ImGuiShowDemoWindow(&open)
//            ImGuiShowMetricsWindow(nil)
//            ImGuiShowStyleEditor(nil)
        }
    }
}
