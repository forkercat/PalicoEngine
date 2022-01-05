//
//  ViewportPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui
import MathLib

class ViewportPanel: Panel {
    var panelName: String { "Viewport" }
    
    var viewportSize: Float2 = Float2(0, 0)
    
    var viewportBoundsMin: Float2 = Float2(0, 0)
    var viewportBoundsMax: Float2 = Float2(0, 0)
    
    var isFocused: Bool = false
    var isHovered: Bool = false
    
    func onImGuiRender() {
        ImGuiPushStyleVar(Int32(ImGuiStyleVar_WindowPadding.rawValue), ImVec2(x: 0, y: 0))
        ImGuiBegin(panelName, nil, 0)
        
        updateViewportSize()
        
        isFocused = ImGuiIsWindowFocused(0)
        isHovered = ImGuiIsWindowHovered(0)
        
        // Blocked Events
//        Application::Get().GetImGuiLayer()->BlockEvents(!m_ViewportFocused && !m_ViewportHovered);
        
        // Get Texture
        
        
        // Gizmo
        
        ImGuiEnd()
        ImGuiPopStyleVar(1)
    }
    
    private func updateViewportSize() {
        var viewportMinRegion: ImVec2 = ImVec2(x: 0, y: 0)
        var viewportMaxRegion: ImVec2 = ImVec2(x: 0, y: 0)
        var viewportOffset: ImVec2 = ImVec2(x: 0, y: 0)
        
        ImGuiGetWindowContentRegionMin(&viewportMinRegion)
        ImGuiGetWindowContentRegionMax(&viewportMaxRegion)
        ImGuiGetWindowPos(&viewportOffset)
        
        viewportBoundsMin = Float2(x: viewportMinRegion.x + viewportOffset.x,
                                   y: viewportMinRegion.y + viewportOffset.y)
        viewportBoundsMax = Float2(x: viewportMaxRegion.x + viewportOffset.x,
                                   y: viewportMaxRegion.y + viewportOffset.y)
        
        var viewportPanelSize: ImVec2 = ImVec2(x: 0, y: 0)
        ImGuiGetContentRegionAvail(&viewportPanelSize)
        
        viewportSize = Float2(viewportPanelSize.x, viewportPanelSize.y)
    }
}
