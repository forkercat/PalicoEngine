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
    
    var viewportSize: Int2 = Int2(0, 0)
    
    var viewportBoundsMin: Float2 = Float2(0, 0)
    var viewportBoundsMax: Float2 = Float2(0, 0)
    
    var isFocused: Bool = false
    var isHovered: Bool = false
    
    var currentRenderPassType: RenderPassType = .colorPass
    var currentTargetType: RenderPass.Target = .color
    
    var editorCamera: EditorCamera = EditorCamera()
    
    func onAttach() {
        editorCamera = EditorCamera(fov: 30.0, aspect: 1.778)
    }
    
    func onUpdate(deltaTime ts: Timestep) {
        editorCamera.onUpdate(deltaTime: ts)
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
            // Log.warn("Viewport size has zero width or height. Skipping resize!")
            return false
        }
        
        let currentRenderPassSize: Int2 = Renderer.getRenderPass(type: currentRenderPassType).size
        
        if currentRenderPassSize.width != viewportSize.width || currentRenderPassSize.height != viewportSize.height {
            // Resize
            resizeRenderPassAndCameras()
            return true
        }
        
        return false
    }
    
    private func resizeRenderPassAndCameras() {
        // Log.debug("Resizing viewport: \(viewportSize)")
        Renderer.resizeRenderPass(type: currentRenderPassType, size: Int2(viewportSize.width, viewportSize.height))
        editorCamera.setViewportSize(viewportSize)
    }
}

// Functions called during ImGui rendering
extension ViewportPanel{
    func onImGuiRender() {
        ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowPadding), ImVec2(0, 0))
        ImGuiBegin(panelName, nil, ImGuiFlag_None)
        
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
        
        viewportBoundsMin = Float2(x: viewportMinRegion.x + viewportOffset.x,
                                   y: viewportMinRegion.y + viewportOffset.y)
        viewportBoundsMax = Float2(x: viewportMaxRegion.x + viewportOffset.x,
                                   y: viewportMaxRegion.y + viewportOffset.y)
        
        var viewportPanelSize: ImVec2 = ImVec2(0, 0)
        ImGuiGetContentRegionAvail(&viewportPanelSize)
        
        viewportSize = Int2(Int(viewportPanelSize.x), Int(viewportPanelSize.y))
    }
    
    private func updateViewportTexture() {
        let textureID: ImTextureID = withUnsafePointer(to: &Renderer.getRenderPass(type: currentRenderPassType).colorTexture) { ptr in
            return UnsafeMutableRawPointer(mutating: ptr)
        }
        
        ImGuiImage(textureID, ImVec2(Float(viewportSize.width), Float(viewportSize.height)),
                   ImVec2(0, 0), ImVec2(1, 1), ImVec4(1), ImVec4(0))
    }
}
