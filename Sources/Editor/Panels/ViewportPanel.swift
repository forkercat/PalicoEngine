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
    var panelName: String { "Editor Camera" }
    
    var viewportSize: Int2 = [0, 0]
    var viewportLoadedFirstTime: Bool = false
    
    var viewportBoundsMin: Float2 = [0, 0]
    var viewportBoundsMax: Float2 = [0, 0]
    
    var isFocused: Bool = false
    var isHovered: Bool = false
    
    var currentRenderPassType: RenderPassType = .colorPass
    var currentTargetType: RenderPass.Target = .color
    
    var editorCamera: EditorCamera = EditorCamera()
    
    func onAttach() {
        editorCamera = EditorCamera(fov: 45.0, aspect: 1.778)
    }
    
    func onUpdate(deltaTime ts: Timestep) {
        if isHovered {
            editorCamera.onUpdate(deltaTime: ts)
        }
    }
    
    func onEvent(event: Event) {
        // TODO: Verify later if it works as expected in any case!
        if event.eventType == .mouseScrolled && !isHovered {
            return
        }
        
        if isFocused || isHovered {
            editorCamera.onEvent(event: event)
        }
    }
    
    func checkIfViewportNeedsResize() -> Bool {
        guard viewportSize.width > 0 && viewportSize.height > 0 else {
            Console.warn("Viewport size has zero width or height. Skipping resize!")
            return false
        }
        
        // ImGui Viewport is intialized with different sizes for the first time.
        // I think this should be the window size. So let's skip it first to avoid
        // some resizing effect in application launch.
        guard viewportLoadedFirstTime else {
            viewportLoadedFirstTime = true
            return false
        }
        
        let currentRenderPassSize: Int2 = Renderer.getRenderPass(type: currentRenderPassType).size
        let textureWidth: Int = viewportSize.width * Renderer.dpi
        let textureHeight: Int = viewportSize.height * Renderer.dpi
        
        if currentRenderPassSize.width != textureWidth || currentRenderPassSize.height != textureHeight {
            // Resize
            Renderer.resizeRenderPass(type: currentRenderPassType, size: [textureWidth, textureHeight])
            editorCamera.setViewportSize(viewportSize)
            return true
        }
        
        return false
    }
}

// Functions called during ImGui rendering
extension ViewportPanel{
    func onImGuiRender() {
        ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowPadding), ImVec2(0, 0))
        ImGuiBegin("\(FAIcon.video) \(panelName)", nil, ImGuiFlag_None)
        
        updateViewportSize()
        
        isFocused = ImGuiIsWindowFocused(ImGuiFlag_None)
        isHovered = ImGuiIsWindowHovered(ImGuiFlag_None)
        
        // Tell ImGuiLayer if it should handle events and do not dispatch them to following layers.
        // If viewport is EITHER hovered OR focused, ImGui should not get the chance to block events.
        // Otherwise, it is possible to block events.
        Application.shared?.SetShouldImGuiTryToBlockEvents(!isFocused && !isHovered)
        
        updateViewportTexture()
        
        // Gizmo
        
        ImGuiEnd()
        ImGuiPopStyleVar(1)
    }
    
    private func updateViewportSize() {
        var viewportMinRegion: ImVec2 = ImVec2(0, 0)
        var viewportMaxRegion: ImVec2 = ImVec2(0, 0)
        var viewportOffset: ImVec2 = ImVec2(0, 0)
        
        ImGuiGetWindowContentRegionMin(&viewportMinRegion)
        ImGuiGetWindowContentRegionMax(&viewportMaxRegion)
        ImGuiGetWindowPos(&viewportOffset)
        
        viewportBoundsMin = [viewportMinRegion.x + viewportOffset.x,
                             viewportMinRegion.y + viewportOffset.y]
        viewportBoundsMax = [viewportMaxRegion.x + viewportOffset.x,
                             viewportMaxRegion.y + viewportOffset.y]
        
        var viewportPanelSize: ImVec2 = ImVec2(0, 0)
        ImGuiGetContentRegionAvail(&viewportPanelSize)
        
        viewportSize = [Int(viewportPanelSize.x), Int(viewportPanelSize.y)]
    }
    
    private func updateViewportTexture() {
        let textureID: ImTextureID = withUnsafePointer(to: &Renderer.getRenderPass(type: currentRenderPassType).colorTexture) { ptr in
            return UnsafeMutableRawPointer(mutating: ptr)
        }
        
        ImGuiImage(textureID, ImVec2(Float(viewportSize.width), Float(viewportSize.height)),
                   ImVec2(0, 0), ImVec2(1, 1), ImVec4(1), ImVec4(0))
    }
}
