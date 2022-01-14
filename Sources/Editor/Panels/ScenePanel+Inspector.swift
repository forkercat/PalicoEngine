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
            ImGuiShowStyleEditor(nil)
            // ImGuiShowUserGuide()
            
            ImGuiEnd()
            return
        }
        
        let gameObject = scene.getGameObjectBy(entityID: selectedEntityID)
        
        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(6, 2))
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(8, 6))
        
        drawHeader(gameObject)
        drawComponents(gameObject)
        
        ImGuiPopStyleVar(2)
        
        ImGuiEnd()
    }
    
    private func drawHeader(_ gameObject: GameObject) {
        var inputValue: String? = gameObject.name
        
        var icon = FAIcon.cube
        if gameObject is Primitive {
            icon = FAIcon.shapes
        } else if gameObject is SceneLight {
            icon = FAIcon.lightbulb
        }
        ImGuiTextV("\(icon)")
        
        ImGuiSameLine(0, -1)
        
        ImGuiCheckbox("##GameObjectEnabled", &gameObject.enabled)
        
        ImGuiSameLine(0, -1)
        
        // TODO: FIXME - Not working!
        if ImGuiInputText("##GameObjectName", &inputValue, 50, Im(ImGuiInputTextFlags_EnterReturnsTrue) | Im(ImGuiInputTextFlags_ReadOnly), { a -> Int32 in
            return 1
        }, nil) { print(inputValue ?? "") }
        
        ImGuiSameLine(0, -1)
        
        if ImGuiButton("\(FAIcon.trashAlt) Delete", ImVec2(0, 0)) {
            
        }
        
        // Tag Component
        /*
        let tagComponent = gameObject.getComponent(TagComponent.self)
        var tag: Int32 = Int32(tagComponent.tag.rawValue)
        if ImGuiCombo("##GameObjectTag", &tag, TagComponent.Tag.tagStrings,
                      Int32(TagComponent.Tag.tagStrings.count), -1) {
            tagComponent.tag = TagComponent.Tag(rawValue: Int(tag))!
        }
        */
        
        ImGuiSeparator()
    }
    
    func drawComponents(_ gameObject: GameObject) {
        
//        ImGuiPopItemWidth()
        
//        // Add Component Button
//        ImGuiSameLine(0, -1)
//        ImGuiPushItemWidth(-1)
//        if ImGuiButton("Add Component", ImVec2(0, 0)) {
//
//        }
//        ImGuiPopItemWidth()
        
        /*
        ImGui::SameLine();
        ImGui::PushItemWidth(-1);  // align 1 pixel to the right of window
        
        if (ImGui::Button("Add Component"))
            ImGui::OpenPopup("AddComponent");
        
        if (ImGui::BeginPopup("AddComponent"))
        {
            if (ImGui::MenuItem("Camera"))
            {
                if (!m_SelectionContext.HasComponent<CameraComponent>())
                    m_SelectionContext.AddComponent<CameraComponent>();
                else
                    PL_WARN("This entity already has the Camera Component!");
                ImGui::CloseCurrentPopup();
            }
            
            if (ImGui::MenuItem("Sprite Component"))
            {
                if (!m_SelectionContext.HasComponent<SpriteRendererComponent>())
                    m_SelectionContext.AddComponent<SpriteRendererComponent>();
                else
                    PL_WARN("This entity already has the Sprite Renderer Component!");
                ImGui::CloseCurrentPopup();
            }
            
            ImGui::EndPopup();
        }
        
        ImGui::PopItemWidth();
        */
        
        drawComponent(TagComponent.self, gameObject, widgets: { component in
            ImGuiTextV("---------- \(component.tag)")
        })
        
        drawComponent(TransformComponent.self, gameObject, widgets: { component in
            ImGuiTextV("---------- \(component.position)")
        })
        
        // MeshRenderer
        
        //
    }
    
    private func drawComponent<T: Component>(_ type: T.Type, _ gameObject: GameObject, widgets drawWidgets: (T) -> Void) {
        let treeNodeFlags = Im(ImGuiTreeNodeFlags_DefaultOpen) | Im(ImGuiTreeNodeFlags_SpanAvailWidth) | Im(ImGuiTreeNodeFlags_Framed)
            | Im(ImGuiTreeNodeFlags_AllowItemOverlap) | Im(ImGuiTreeNodeFlags_FramePadding)
        
        guard gameObject.hasComponent(type) else {
            return
        }
    
        let component = gameObject.getComponent(type)
        
        var contentRegionAvailable: ImVec2 = ImVec2(0, 0)
        ImGuiGetContentRegionAvail(&contentRegionAvailable)
        
        let fontSize = ImGuiGetFont().pointee.FontSize / Float(Renderer.dpi)
//        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(4, 4))
        let lineHeight: Float = fontSize + ImGuiGetStyle().pointee.FramePadding.y * 2.0
        let opened: Bool = ImGuiTreeNodeEx(component.title, treeNodeFlags)
//        ImGuiPopStyleVar(1)  // FramePadding
        
        ImGuiSameLine(contentRegionAvailable.x - lineHeight, -1.0)  // -1.0 is default value
        if ImGuiButton("\(FAIcon.bars)", ImVec2(0, lineHeight)) {
            // fa-align-justify
            ImGuiOpenPopup("##ComponentSettings", 0)
        }
        
        var shouldRemoveComponent: Bool = false
        if ImGuiBeginPopup("##ComponentSettings", 0) {
            if ImGuiMenuItem("\(FAIcon.trashAlt) Remove", nil, false, true) {
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
    }
    
    private static func drawFloat3(_ label: String, _ values: inout Float3, _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
        ImGuiDragFloat3(label, &values, 0.1, 0, 0, "%.3f", 0)
    }
}