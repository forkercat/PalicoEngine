//
//  ViewportPanel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico
import ImGui
import ImGuizmo
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
    
    var gizmoType: ImGuizmoType = .translate
    
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
    func onImGuiRender() { }
    func onImGuiRender(_ gameObject: GameObject?) {
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
        if gizmoType != .none && gameObject != nil {
            renderGizmo(gameObject!)
        }
        drawGizmoControl()
        
        ImGuiEnd()
        ImGuiPopStyleVar(1)
    }
    
    private func renderGizmo(_ gameObject: GameObject) {
        ImGuizmoSetOrthographic(false)
        ImGuizmoSetDrawlist(nil)
        ImGuizmoSetRect(viewportBoundsMin.x, viewportBoundsMin.y,
                        viewportBoundsMax.x - viewportBoundsMin.x,
                        viewportBoundsMax.y - viewportBoundsMin.y)
        
        let viewMatrix: Float4x4 = editorCamera.viewMatrix
        let projectionMatrix: Float4x4 = editorCamera.projectionMatrix
        let transform = gameObject.getComponent(TransformComponent.self)
        var modelMatrix: Float4x4 = transform.modelMatrix
        
        // Snapping
        let snap: Bool = Input.isPressed(key: .shift)
        var snapValues: Float3 = (gizmoType == .rotate) ? Float3(repeating: 45.0) : Float3(repeating: 0.5)
        
        withUnsafeBytes(of: viewMatrix) { (view: UnsafeRawBufferPointer) -> Void in
            withUnsafeBytes(of: projectionMatrix) { (project: UnsafeRawBufferPointer) -> Void in
                withUnsafeMutableBytes(of: &modelMatrix) { (model: UnsafeMutableRawBufferPointer) -> Void in
                    withUnsafeMutableBytes(of: &snapValues, { (values: UnsafeMutableRawBufferPointer) -> Void in
                        ImGuizmoManipulate(view.baseAddress!.assumingMemoryBound(to: Float.self),
                                           project.baseAddress!.assumingMemoryBound(to: Float.self),
                                           OPERATION(rawValue: UInt32(gizmoType.rawValue)),
                                           MODE(rawValue: UInt32(ImGuizmoMode.local.rawValue)),
                                           model.baseAddress!.assumingMemoryBound(to: Float.self),
                                           nil, (snap) ? values.baseAddress!.assumingMemoryBound(to: Float.self) : nil,
                                           nil, nil)
                    })
                }
            }
        }
        
        // Avoid using gizmo when rotating editor camera
        guard !Input.isPressed(key: .command) && !Input.isPressed(key: .option) else {
            return
        }
        
        if ImGuizmoIsUsing() {
            var position: Float3 = [0, 0, 0]
            var rotation: Float3 = [0, 0, 0]
            var scale: Float3 = [0, 0, 0]
            decomposeModelMatrix(modelMatrix: modelMatrix, translation: &position, rotation: &rotation, scale: &scale)
            transform.position = position
            transform.rotation += (rotation - transform.rotation)
            transform.scale = scale
        }
    }
    
    // TODO: Rotation needs to be fixed (currently using XYZ)
    private func decomposeModelMatrix(modelMatrix mat: Float4x4, translation: inout Float3, rotation: inout Float3,
                                 scale: inout Float3) {
        // Scale
        scale.x = length(mat.columns.0.xyz)
        scale.y = length(mat.columns.1.xyz)
        scale.z = length(mat.columns.2.xyz)
        
        // Rotation
        let c0 = normalize(mat.columns.0.xyz)
        let c1 = normalize(mat.columns.1.xyz)
        let c2 = normalize(mat.columns.2.xyz)
        rotation.y = atan2f(-c0.z, sqrtf(c1.z * c1.z + c2.z * c2.z))
        rotation.x = atan2f(c1.z, c2.z)
        rotation.z = atan2f(c0.y, c0.x)
        /*
        if cosf(rotation.y) != 0 {
            rotation.x = atan2f(c1.z, c2.z)
            rotation.z = atan2f(c0.y, c0.x)
        } else {
            rotation.x = atan2f(c1.z, c2.z)
            rotation.z = 0
        }
         */
        
        // Translation
        translation = mat.columns.3.xyz
    }
    
    private func drawGizmoControl() {
        let windowFlags: ImGuiWindowFlags = Im(ImGuiWindowFlags_NoDecoration) | Im(ImGuiWindowFlags_NoDocking)
            | Im(ImGuiWindowFlags_AlwaysAutoResize) | Im(ImGuiWindowFlags_NoSavedSettings)
            | Im(ImGuiWindowFlags_NoFocusOnAppearing) | Im(ImGuiWindowFlags_NoNav)
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowBorderSize), 0.0)
        
        var viewportPos: ImVec2 = ImVec2(0, 0)
        ImGuiGetWindowPos(&viewportPos)
        
        let tabBarHeight: Float = 23
        let buttonSize: ImVec2 = ImVec2(32, 23)
        
        var viewportWindowSize: ImVec2 = ImVec2(0, 0)
        ImGuiGetWindowSize(&viewportWindowSize)
        
        let paddingSize: Float = 8.0
        let ySpacing: Float = 8.0
        // let xSpacing: Float = 6.0
        
        
        ImGuiSetNextWindowPos(ImVec2(viewportPos.x + paddingSize, viewportPos.y + tabBarHeight + paddingSize), 0, ImVec2(0, 0))
        ImGuiSetNextWindowSize(ImVec2(buttonSize.x, buttonSize.y * 4 + ySpacing * 3), 0)
        
        ImGuiBegin("GizmoControl", nil, windowFlags)
        drawGizmoTypeButton("\(FAIcon.handRock)", .none, buttonSize)
        // ImGuiSameLine(0, xSpacing)
        ImGuiSpacing()
        drawGizmoTypeButton("\(FAIcon.arrowsAlt)", .translate, buttonSize)
        // ImGuiSameLine(0, xSpacing)
        ImGuiSpacing()
        drawGizmoTypeButton("\(FAIcon.syncAlt)", .rotate, buttonSize)
        // ImGuiSameLine(0, xSpacing)
        ImGuiSpacing()
        drawGizmoTypeButton("\(FAIcon.expand)", .scale, buttonSize)
        
        ImGuiPopStyleVar(1)
        ImGuiEnd()  // GizmoControl
    }
    
    private func drawGizmoTypeButton(_ icon: String, _ type: ImGuizmoType, _ buttonSize: ImVec2 = ImVec2(0, 0)) {
        ImGuiPushID("GizmoTypeButton\(icon)");
        if (gizmoType == type)  // enabled
        {
            ImGuiPushStyleColor(Im(ImGuiCol_Button), ImVec4(0.3, 0.305, 0.31, 1.0))
            ImGuiPushStyleColor(Im(ImGuiCol_ButtonHovered), ImVec4(0.3, 0.305, 0.31, 1.0))
            ImGuiPushStyleColor(Im(ImGuiCol_ButtonActive), ImVec4(0.3, 0.305, 0.31, 1.0))
            ImGuiButton(icon, buttonSize)
            if ImGuiIsItemClicked(Im(ImGuiMouseButton_Left)) { gizmoType = type }
            ImGuiPopStyleColor(3);
        }
        else {
            ImGuiPushStyleColor(Im(ImGuiCol_Button), ImVec4(0.2, 0.205, 0.21, 1.0))
            ImGuiPushStyleColor(Im(ImGuiCol_ButtonHovered), ImVec4(0.2, 0.205, 0.21, 1.0))
            ImGuiPushStyleColor(Im(ImGuiCol_ButtonActive), ImVec4(0.2, 0.205, 0.21, 1.0))
            if ImGuiButton(icon, buttonSize) { gizmoType = type }
            ImGuiPopStyleColor(3)
        }
        ImGuiPopID();
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
