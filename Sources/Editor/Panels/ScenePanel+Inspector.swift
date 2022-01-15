//
//  ScenePanel+Inspector.swift
//  Editor
//
//  Created by Junhao Wang on 1/13/22.
//

import Palico
import ImGui
import MathLib
import MothECS

extension ScenePanel {
    func drawInspectorPanel() {
        ImGuiBegin("\(FAIcon.palette) \(inspectorPanelName)", nil, 0)
        
        guard selectedEntityID != .invalid else {
            // ImGuiShowStyleEditor(nil)
            // ImGuiShowUserGuide()
            
            ImGuiEnd()
            return
        }
        
        let gameObject = scene.getGameObjectBy(entityID: selectedEntityID)
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(6, 2))
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(8, 8))
        
        let shouldDeleteGameObject: Bool = drawHeader(gameObject)
        
        if shouldDeleteGameObject {
            scene.destroyGameObject(gameObject)
            selectedEntityID = .invalid
        } else {
            drawComponents(gameObject)
        }
        
        ImGuiSeparator()
        
        drawAddComponentButton(gameObject)
        
        ImGuiPopStyleVar(2)
        
        ImGuiEnd()
    }
    
    private func drawHeader(_ gameObject: GameObject) -> Bool {
        var shouldDeleteGameObject: Bool = false
        var inputValue: String? = gameObject.name
        
        let leftPanelWidth: Float = 35
        let panelHeight: Float = 50
        
        // Icon
        ImGuiBeginChild("##Left Pane", ImVec2(leftPanelWidth, panelHeight), false, 0)
        
        var icon = FAIcon.cube
        if gameObject is Primitive {
            icon = FAIcon.shapes
        } else if gameObject is SceneLight {
            icon = FAIcon.lightbulb
        }
        
        ImGuiPushFont(ImGuiFontLibrary.largeIcon)
        let iconItemSize: Float = 26
        var leftPaneWindowSize: ImVec2 = ImVec2(0, 0)
        ImGuiGetWindowSize(&leftPaneWindowSize)
        ImGuiSetCursorPosX(7.0)
        ImGuiSetCursorPosY((leftPaneWindowSize.y - iconItemSize) / 2.0)
        ImGuiPushItemWidth(iconItemSize)
        ImGuiTextV("\(icon)")
        ImGuiPopItemWidth()
        ImGuiPopFont()
        
        ImGuiEndChild()  // left pane
        
        ImGuiSameLine(0, 5)
        
        // Right
        ImGuiBeginChild("##Right Pane", ImVec2(0, panelHeight), false, 0)
        
        var contentRegionAvailable: ImVec2 = ImVec2(0, 0)
        ImGuiGetContentRegionAvail(&contentRegionAvailable)
        
        ImGuiCheckbox("##GameObjectEnabled", &gameObject.enabled)
        
        ImGuiSameLine(0, -1)
        
        // TODO: FIXME - Not working!
        let deleteButtonSize: Float = 75
        ImGuiSetNextItemWidth(contentRegionAvailable.x - deleteButtonSize - 37)  // TODO: should be calculated
        if ImGuiInputText("##GameObjectName", &inputValue, 50, Im(ImGuiInputTextFlags_EnterReturnsTrue) | Im(ImGuiInputTextFlags_ReadOnly), { a -> Int32 in
            return 1
        }, nil) { print(inputValue ?? "") }
        
        ImGuiSameLine(contentRegionAvailable.x - deleteButtonSize, -1)
        if ImGuiButton("\(FAIcon.trashAlt) Delete", ImVec2(deleteButtonSize, 0)) {
            shouldDeleteGameObject = true
        }
        
        // Tag Component
        ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
        ImGuiPushItemWidth(contentRegionAvailable.x)
        let tagComponent = gameObject.getComponent(TagComponent.self)
        var tag: Int32 = Int32(tagComponent.tag.rawValue)
        if ImGuiCombo("##TagComponent", &tag, TagComponent.Tag.tagStringsWithIcon,
                      Int32(TagComponent.Tag.tagStrings.count), -1) {
            tagComponent.tag = TagComponent.Tag(rawValue: Int(tag))!
        }
        
        ImGuiEndChild()  // right pane
                
        ImGuiSeparator()
        
        return shouldDeleteGameObject
    }
    
    func drawComponents(_ gameObject: GameObject) {
        let labelColumnWidth: Float = 70
        
        drawComponent(TransformComponent.self, gameObject, widgets: { component in
            Self.drawControlFloat3("Position", &component.position, "%.2f", 0.0, labelColumnWidth)
            var rotationInDegrees: Float3 = component.rotation.toDegrees
            Self.drawControlFloat3("Rotation", &rotationInDegrees, "%.2f", 0.0, labelColumnWidth)
            component.rotation = rotationInDegrees.toRadians
            Self.drawControlFloat3("Scale", &component.scale, "%.2f", 0.0, labelColumnWidth)
        })
        
        drawComponent(MeshRendererComponent.self, gameObject, widgets: { component in
            ImGuiTextV("Mesh: \(String(describing: component.mesh?.nativeMesh.name ?? "unknown"))")
            ImGuiColorEdit4("Tint Color", &component.tintColor, Im(ImGuiColorEditFlags_None))
        })
        
        drawComponent(LightComponent.self, gameObject, widgets: { component in
            var lightType: Int32 = Int32(component.light.type.rawValue)
            if ImGuiCombo("Type", &lightType, LightType.typeStrings,
                          Int32(LightType.typeStrings.count), -1) {
                component.setLightType(LightType(rawValue: lightType)!)
            }
            ImGuiColorEdit3("Color", &component.light.color, Im(ImGuiColorEditFlags_None))
            ImGuiSliderFloat("Intensity", &component.light.intensity, 0.0, 1.0, "%.2f", 0)
        })
        
        drawComponent(CameraComponent.self, gameObject, widgets: { component in
            ImGuiTextV("\(component.title)")
        })
        
        drawComponent(ScriptComponent.self, gameObject, widgets: { component in
            ImGuiTextV("\(component.title): printf(Hello Palico!)")
        })
    }
    
    private func drawComponent<T: Component>(_ type: T.Type, _ gameObject: GameObject, widgets drawWidgets: (T) -> Void) {
        let treeNodeFlags = Im(ImGuiTreeNodeFlags_DefaultOpen) | Im(ImGuiTreeNodeFlags_SpanAvailWidth) | Im(ImGuiTreeNodeFlags_Framed)
            | Im(ImGuiTreeNodeFlags_AllowItemOverlap) | Im(ImGuiTreeNodeFlags_FramePadding)
//            | Im(ImGuiTreeNodeFlags_Leaf)
//            | Im(ImGuiTreeNodeFlags_Bullet)
        
        guard gameObject.hasComponent(type) else {
            return
        }
    
        ImGuiPushStyleColor(Im(ImGuiCol_Header), ImVec4(0.2, 0.205, 0.21, 1.0))
        ImGuiPushStyleColor(Im(ImGuiCol_HeaderHovered), ImVec4(0.2, 0.205, 0.21, 1.0))
        ImGuiPushStyleColor(Im(ImGuiCol_HeaderActive), ImVec4(0.2, 0.205, 0.21, 1.0))
        
        let component = gameObject.getComponent(type)
        
        var contentRegionAvailable: ImVec2 = ImVec2(0, 0)
        ImGuiGetContentRegionAvail(&contentRegionAvailable)
        
        // Header
        let fontSize = ImGuiGetFont().pointee.FontSize / Float(Renderer.dpi)
        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(1, 2))
        let lineHeight: Float = fontSize + ImGuiGetStyle().pointee.FramePadding.y * 2.0
        let opened: Bool = ImGuiTreeNodeEx("\(T.icon) \(component.title)", treeNodeFlags)
        ImGuiPopStyleVar(1)  // FramePadding
        
        // Component Status
        if type != TransformComponent.self {
            ImGuiSameLine(contentRegionAvailable.x - lineHeight - 22 + 4.0, -1)
            ImGuiPushStyleColor(Im(ImGuiCol_FrameBg), ImVec4(0.3, 0.305, 0.31, 1.0))
            // TODO: Checkmark Color
            ImGuiCheckbox("##ComponentCheckboxEnabled", &component.enabled)
            ImGuiPopStyleColor(1)
        }
        
        // Component Settings Button
        ImGuiSameLine(contentRegionAvailable.x - lineHeight + 4.0, -1)  // -1.0 is default value
        ImGuiPushStyleColor(Im(ImGuiCol_Button), ImVec4(0.2, 0.205, 0.21, 1.0))
        ImGuiPushStyleColor(Im(ImGuiCol_ButtonHovered), ImVec4(0.2, 0.205, 0.21, 1.0))
        ImGuiPushStyleColor(Im(ImGuiCol_ButtonActive), ImVec4(0.2, 0.205, 0.21, 1.0))
        if ImGuiButton("\(FAIcon.bars)", ImVec2(lineHeight, lineHeight)) {
            // fa-align-justify
            ImGuiOpenPopup("##ComponentSettings", 0)
        }
        ImGuiPopStyleColor(3)
        
        var shouldRemoveComponent: Bool = false
        if ImGuiBeginPopup("##ComponentSettings", 0) {
            if ImGuiMenuItem("\(FAIcon.trashAlt) Delete", nil, false, true) {
                shouldRemoveComponent = true
            }
            ImGuiEndPopup()
        }
        
        if opened {
            drawWidgets(component)
            ImGuiTreePop()
        }
        
        if shouldRemoveComponent {
            gameObject.removeComponent(type)
        }
        
        ImGuiPopStyleColor(3)
    }
    
    private static func drawControlFloat3(_ label: String, _ values: inout Float3, _ format: String = "%.1f", _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
        ImGuiPushID(label)
        ImGuiColumns(2, nil, false)
        
        ImGuiSetColumnWidth(0, columnWidth)
        ImGuiTextV(label)
        ImGuiNextColumn()
        
        ImGuiPushMultiItemsWidths(3, ImGuiCalcItemWidth())
        
        let itemInnerSpacing: Float = 4
        let itemOutterSpacing: Float = 4
        
        // X
        if ImGuiButton("X", ImVec2(0, 0)) {
            values.x = resetValue
        }
        ImGuiSameLine(0, itemInnerSpacing)
        ImGuiDragFloat("##X", &values.x, 0.1, 0.0, 0.0, format, 0)
        ImGuiPopItemWidth()
        ImGuiSameLine(0, itemOutterSpacing)
        
        // Y
        if ImGuiButton("Y", ImVec2(0, 0)) {
            values.y = resetValue
        }
        ImGuiSameLine(0, itemInnerSpacing)
        ImGuiDragFloat("##Y", &values.y, 0.1, 0.0, 0.0, format, 0)
        ImGuiPopItemWidth()
        ImGuiSameLine(0, itemOutterSpacing)
        
        // Z
        if ImGuiButton("Z", ImVec2(0, 0)) {
            values.z = resetValue
        }
        ImGuiSameLine(0, itemInnerSpacing)
        ImGuiDragFloat("##Z", &values.z, 0.1, 0.0, 0.0, format, 0)
        ImGuiPopItemWidth()
        
        ImGuiColumns(1, nil, false)
        ImGuiPopID()  // pop ID label
    }
    
    private static func drawControlFloat2(_ label: String, _ values: inout Float2, _ format: String = "%.1f", _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
        ImGuiPushID(label)
        ImGuiColumns(2, nil, false)
        
        ImGuiSetColumnWidth(0, columnWidth)
        ImGuiTextV(label)
        ImGuiNextColumn()
        
        ImGuiPushMultiItemsWidths(2, ImGuiCalcItemWidth())
        
        let itemInnerSpacing: Float = 4
        let itemOutterSpacing: Float = 4
        
        // X
        if ImGuiButton("X", ImVec2(0, 0)) {
            values.x = resetValue
        }
        ImGuiSameLine(0, itemInnerSpacing)
        ImGuiDragFloat("##X", &values.x, 0.1, 0.0, 0.0, format, 0)
        ImGuiPopItemWidth()
        ImGuiSameLine(0, itemOutterSpacing)
        
        // Y
        if ImGuiButton("Y", ImVec2(0, 0)) {
            values.y = resetValue
        }
        ImGuiSameLine(0, itemInnerSpacing)
        ImGuiDragFloat("##Y", &values.y, 0.1, 0.0, 0.0, format, 0)
        ImGuiPopItemWidth()
        
        ImGuiColumns(1, nil, false)
        ImGuiPopID()  // pop ID label
    }
    
    private func drawAddComponentButton(_ gameObject: GameObject) {
        var windowSize: ImVec2 = ImVec2(0, 0)
        let buttonSize: Float = 138.0
        ImGuiGetWindowSize(&windowSize)
        ImGuiSetCursorPosX(windowSize.x / 2.0 - buttonSize / 2.0)
        
        if ImGuiButton("\(FAIcon.plus) Add Component", ImVec2(140, 26)) {
            ImGuiOpenPopup("AddComponentPopup", 0)
        }
        
        if ImGuiBeginPopup("AddComponentPopup", 0) {
            drawComponentCreationMenuItems(gameObject)
            ImGuiEndPopup()
        }
    }
    
    func drawComponentCreationMenuItems(_ gameObject: GameObject) {
        if ImGuiMenuItem("\(MeshRendererComponent.icon) Mesh Renderer", nil, false, true) {
            guard !gameObject.hasComponent(MeshRendererComponent.self) else {
                Console.warn("\(MeshRendererComponent.self) has already existed!")
                return
            }
            gameObject.addComponent(MeshRendererComponent.self)
        }
        
        if ImGuiMenuItem("\(LightComponent.icon) Light", nil, false, true) {
            guard !gameObject.hasComponent(LightComponent.self) else {
                Console.warn("\(LightComponent.self) has already existed!")
                return
            }
            gameObject.addComponent(LightComponent.self)
        }
        
        if ImGuiMenuItem("\(CameraComponent.icon) Camera", nil, false, true) {
            guard !gameObject.hasComponent(CameraComponent.self) else {
                Console.warn("\(CameraComponent.self) has already existed!")
                return
            }
            gameObject.addComponent(CameraComponent.self)
        }
        
        if ImGuiMenuItem("\(ScriptComponent.icon) Script", nil, false, true) {
            guard !gameObject.hasComponent(ScriptComponent.self) else {
                Console.warn("\(ScriptComponent.self) has already existed!")
                return
            }
            gameObject.addComponent(ScriptComponent.self)
        }
    }

}
