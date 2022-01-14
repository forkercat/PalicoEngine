//
//  ScenePanel+Hierarchy.swift
//  Editor
//
//  Created by Junhao Wang on 1/13/22.
//

import Palico
import ImGui

extension ScenePanel {
    func drawHierarchyPanel() {
        ImGuiBegin("\(FAIcon.list) \(hierarchyPanelName)", nil, 0)
        
        let gameObjectList = scene.gameObjectList
        for gameObject in gameObjectList {
            drawGameObjectNode(gameObject)
        }
        
        // Left-click on blank space: Delete game object
        if ImGuiIsMouseClicked(Im(ImGuiMouseButton_Left), false) && ImGuiIsWindowHovered(0) {
            selectedEntityID = .invalid
        }
        
        // Right-click on blank space: Pop-up for creation
        if ImGuiBeginPopupContextWindow(nil, Im(ImGuiPopupFlags_MouseButtonRight) | Im(ImGuiPopupFlags_NoOpenOverItems)) {
            drawGameObjectCreationMenuItems()
            ImGuiEndPopup()
        }
        
        ImGuiEnd()
    }
    
    private func drawGameObjectNode(_ gameObject: GameObject) {
        ImGuiPushStyleVar(Im(ImGuiStyleVar_ItemSpacing), ImVec2(8, 6))
        ImGuiPushStyleVar(Im(ImGuiStyleVar_FramePadding), ImVec2(1, 3))
        
        var flags: ImGuiTreeNodeFlags = Im(ImGuiTreeNodeFlags_SpanAvailWidth) | Im(ImGuiTreeNodeFlags_OpenOnArrow) | Im(ImGuiTreeNodeFlags_OpenOnDoubleClick)
        flags |= (gameObject.entityID == selectedEntityID) ? Im(ImGuiTreeNodeFlags_Selected) : 0
        
        var icon: String = FAIcon.cube
        if gameObject is Primitive {
            icon = FAIcon.shapes
        } else if gameObject is SceneLight {
            icon = FAIcon.lightbulb
        }
        
        let opened: Bool = ImGuiTreeNodeEx("\(icon) \(gameObject.name)", flags)
        // let opened: Bool = ImGuiTreeNodeEx("\(icon) [ID: \(gameObject.entityID)] \(gameObject.name)", flags)
        
        if ImGuiIsItemClicked(Im(ImGuiMouseButton_Left)) {
            selectedEntityID = gameObject.entityID
        }
        
        // Delete Game Object
        var isGameObjectDeleted: Bool = false
        if ImGuiBeginPopupContextItem(nil, 1) {
            if ImGuiMenuItem("\(FAIcon.trashAlt) Delete", nil, false, true) {
                isGameObjectDeleted = true
            }
            ImGuiEndPopup()
        }
        
        if opened {
            ImGuiTextV("EntityID: \(gameObject.entityID)")
            ImGuiTreePop()
        }
        
        ImGuiPopStyleVar(2)  // ItemSpacing & FramePadding
        
        // Hanlde Deletion
        if isGameObjectDeleted {
            scene.destroyGameObject(gameObject)
            selectedEntityID = .invalid
        }
    }
    
    func drawGameObjectCreationMenuItems() {
        if ImGuiMenuItem("\(FAIcon.cube) Create Empty", nil, false, true) {
            scene.createEmptyGameObject()
        }
        
        if ImGuiBeginMenu("\(FAIcon.shapes) Create Primitives", true) {
            if ImGuiMenuItem("Cube", nil, false, true) {
                scene.createPrimitive(type: .cube)
            }
            if ImGuiMenuItem("Sphere", nil, false, true) {
                scene.createPrimitive(type: .sphere)
            }
            if ImGuiMenuItem("Hemisphere", nil, false, true) {
                scene.createPrimitive(type: .hemisphere)
            }
            if ImGuiMenuItem("Plane", nil, false, true) {
                scene.createPrimitive(type: .plane)
            }
            if ImGuiMenuItem("Capsule", nil, false, true) {
                scene.createPrimitive(type: .capsule)
            }
            if ImGuiMenuItem("Cylinder", nil, false, true) {
                scene.createPrimitive(type: .cylinder)
            }
            if ImGuiMenuItem("Cone", nil, false, true) {
                scene.createPrimitive(type: .cone)
            }
            ImGuiEndMenu()
        }
        
        if ImGuiBeginMenu("\(FAIcon.lightbulb) Create Lights", true) {
            if ImGuiMenuItem("Directional Light", nil, false, true) {
                scene.createSceneLight(type: .dirLight)
            }
            if ImGuiMenuItem("Point Light", nil, false, true) {
                scene.createSceneLight(type: .pointLight)
            }
            if ImGuiMenuItem("Spot Light", nil, false, true) {
                scene.createSceneLight(type: .spotLight)
            }
            if ImGuiMenuItem("Ambient Light", nil, false, true) {
                scene.createSceneLight(type: .ambientLight)
            }
            ImGuiEndMenu()
        }
    }
}
