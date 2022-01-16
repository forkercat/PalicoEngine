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
    
    var autoScrolled: Bool = true
    var currentMessageLevel: Int32 = 0
    
    func onImGuiRender() {
        let io = ImGuiGetIO()!
        
        ImGuiBegin("\(FAIcon.terminal) \(panelName)", nil, 0)
        
        // Header
        ImGuiTextV(String(format: "FPS: %.1f (%.3f ms/frame)", io.pointee.Framerate, 1000.0 / io.pointee.Framerate))
        
        // For Debug
        /*
        ImGuiSameLine(0, -1)
        if ImGuiButton("debug", ImVec2(0, 0)) {
            Console.debug("Hi debug - \(Time.currentTime)")
        }
        
        ImGuiSameLine(0, -1)
        if ImGuiButton("info", ImVec2(0, 0)) {
            Console.info("Hi info - \(Time.currentTime)")
        }
        
        ImGuiSameLine(0, -1)
        if ImGuiButton("warn", ImVec2(0, 0)) {
            Console.warn("Hi Warn  - \(Time.currentTime)")
        }
        
        ImGuiSameLine(0, -1)
        if ImGuiButton("error", ImVec2(0, 0)) {
            Console.error("Hi error - \(Time.currentTime)")
        }
         */

        ImGuiSameLine(ImGuiGetWindowWidth() - 150 - 95 - 40, -1)  // TODO: Use calculated width
        ImGuiCheckbox("Auto-Scroll", &autoScrolled)
        ImGuiSameLine(0, -1)
        
        ImGuiPushItemWidth(95)
        ImGuiCombo("##OutputLevelCombo", &currentMessageLevel,
                   Console.Message.Level.levelStringsWithIcons,
                   Int32(Console.Message.Level.numLevels), -1)
        ImGuiPopItemWidth()
        
        ImGuiSameLine(0, -1)
        if ImGuiButton("\(FAIcon.trashAlt) Clear", ImVec2(0, 0)) {
            Console.clear()
        }
        
        ImGuiSeparator()
        ImGuiSpacing()
        
        // Message Region
        ImGuiBeginChild("##ConsoleScrollRegion", ImVec2(0, 0), false, Im(ImGuiWindowFlags_HorizontalScrollbar))

        if ImGuiBeginPopupContextWindow("##ConsoleClearPopup", 1) {
            if ImGuiSelectable("\(FAIcon.trashAlt) Clear", false, ImGuiFlag_None, ImVec2(0, 0)) {
                Console.clear()
            }
            ImGuiEndPopup()
        }
        
        while let message = Console.nextMessage() {
            if message.level.rawValue < currentMessageLevel {
                continue
            }
            
            var color: ImVec4 = ImGuiTheme.text
            
            switch message.level {
            case .debug:
                color = ImGuiTheme.consoleDebug
            case .info:
                color = ImGuiTheme.consoleInfo
            case .warn:
                color = ImGuiTheme.consoleWarn
            case .error:
                color = ImGuiTheme.consoleError
            }
            
            ImGuiPushStyleColor(Im(ImGuiCol_Text), color)
            ImGuiTextV(message.str)
            ImGuiPopStyleColor(1)
        }
        
        // Auto scroll to button
        if autoScrolled && ImGuiGetScrollY() >= ImGuiGetScrollMaxY() {
            ImGuiSetScrollHereY(1.0)
        }

        ImGuiEndChild()
        
        ImGuiEnd()
    }
}
