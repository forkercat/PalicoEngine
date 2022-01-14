//
//  EditorLayer.swift
//  Editor
//
//  Created by Junhao Wang on 12/15/21.
//

import Palico
import ImGui

fileprivate var dockspaceOpen: Bool = true
fileprivate var optFullscreenPersistent: Bool = true
fileprivate var dockspaceFlags: ImGuiDockNodeFlags = Im(ImGuiDockNodeFlags_None)

class EditorLayer: Layer {
    // Panels
    let scenePanel: ScenePanel = ScenePanel()  // Hierarchy Panel + Inspector Panel
    let assetPanel: AssetPanel = AssetPanel()
    let viewportPanel: ViewportPanel = ViewportPanel()
    let consolePanel: ConsolePanel = ConsolePanel()
    let imGuiDemoPanel: ImGuiDemoPanel = ImGuiDemoPanel()
    
    override init() {
        super.init()
    }
    
    override init(name: String = "Editor Layer") {
        super.init(name: name)
    }
    
    override func onAttach() {
        // EditorCamera
        scenePanel.onAttach()
        viewportPanel.onAttach()
        
        // Empty GameObject
        scenePanel.scene.createEmptyGameObject()
        
        // Primitives
        let cube = Cube(scenePanel.scene, name: "Cube", position: [0, 0, 0])
        let cubeMeshRenderer = cube.getComponent(MeshRendererComponent.self)
        cubeMeshRenderer.tintColor = .yellow
        
        let sphere = Sphere(scenePanel.scene, name: "Sphere",
                            position: [-6, 1.5, -4], rotation: [0, 0, 0], scale: [1.5, 1.5, 1.5])
        let capsule = Capsule(scenePanel.scene, name: "Capsule",
                              position: [-0.5, 1, -4])
        let capsuleMeshRenderer = capsule.getComponent(MeshRendererComponent.self)
        capsuleMeshRenderer.tintColor = .green
        let cone = Cone(scenePanel.scene, name: "Cone",
                        position: [0, 1, 0], rotation: [0, 0, 0], scale: [0.8, 1, 0.8])
        let coneMeshRenderer = cone.getComponent(MeshRendererComponent.self)
        coneMeshRenderer.tintColor = .red
        
        let cylinder = Cylinder(scenePanel.scene, name: "Cylinder",
                                position: [-4, 0.5, 0.5], rotation: [0, 0, 0], scale: [1, 1.5, 1])
        let cylinderMeshRenderer = cylinder.getComponent(MeshRendererComponent.self)
        cylinderMeshRenderer.tintColor = .lightBlue
        
        scenePanel.scene.addGameObject(cube)
        scenePanel.scene.addGameObject(sphere)
        scenePanel.scene.addGameObject(capsule)
        scenePanel.scene.addGameObject(cone)
        scenePanel.scene.addGameObject(cylinder)
        
        // Light Data
        let ambientLight = SceneLight(scenePanel.scene, name: "Ambient Light", type: .ambientLight, position: [5, 5, -5])
        let dirLight = SceneLight(scenePanel.scene, name: "Directional Light", type: .dirLight, position: [3, 3, -1])
        let pointLight1 = SceneLight(scenePanel.scene, name: "Point Light #1", type: .pointLight, position: [4, 2, 1.5])
        let pointLight2 = SceneLight(scenePanel.scene, name: "Point Light #2", type: .pointLight, position: [-3, 4, 1.5])
        
        // Config
        let ambientLightTransform = ambientLight.getComponent(TransformComponent.self)
        ambientLightTransform.position = [5, 5, -5]
        
        let dirLightComponent = dirLight.getComponent(LightComponent.self)
        dirLightComponent.light.intensity = 0.6
        dirLightComponent.light.color = .lightYellow
        
        let ambientLightComponent = ambientLight.getComponent(LightComponent.self)
        ambientLightComponent.light.intensity = 0.2
        
        let pointLightComponent1 = pointLight1.getComponent(LightComponent.self)
        pointLightComponent1.light.intensity = 0.5
        pointLightComponent1.light.color = .lightBlue
        
        let pointLightComponent2 = pointLight2.getComponent(LightComponent.self)
        pointLightComponent2.light.intensity = 0.2
        pointLightComponent2.light.color = .red
        
        scenePanel.scene.addGameObjects([ambientLight, dirLight, pointLight1, pointLight2])
    }
    
    override func onDetach() {
        
    }
    
    override func onUpdate(deltaTime ts: Timestep) {
        // Resize
        if viewportPanel.checkIfViewportNeedsResize() {
            // TODO: resize active scene
            
        }
        
        // onUpdate
        scenePanel.onUpdate(deltaTime: ts)
        viewportPanel.onUpdate(deltaTime: ts)
        
        // Render Scene (Editor)
        scenePanel.scene.onRenderEditor(deltaTime: ts, editorCamera: viewportPanel.editorCamera)
        
        // Event
    }
    
    // Called after onUpdate()
    override func onImGuiRender() {
        let optFullscreen: Bool = optFullscreenPersistent
        dockspaceFlags = Im(ImGuiDockNodeFlags_None)
        
        // We are using the ImGuiWindowFlags_NoDocking flag to make the parent window not dockable into,
        // because it would be confusing to have two docking targets within each others.
        var windowFlags: ImGuiWindowFlags = Im(ImGuiWindowFlags_MenuBar) | Im(ImGuiWindowFlags_NoDocking)
        if optFullscreen {
            let viewport = ImGuiGetMainViewport()!
            ImGuiSetNextWindowPos(viewport.pointee.Pos, Im(ImGuiCond_None), ImVec2(0, 0))
            ImGuiSetNextWindowSize(viewport.pointee.Size, Im(ImGuiCond_None))
            ImGuiSetNextWindowViewport(viewport.pointee.ID)
            ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowRounding), 0.0)
            ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowBorderSize), 0.0)
            windowFlags |= Im(ImGuiWindowFlags_NoTitleBar) | Im(ImGuiWindowFlags_NoCollapse) |
                             Im(ImGuiWindowFlags_NoResize) | Im(ImGuiWindowFlags_NoMove)
            windowFlags |= Im(ImGuiWindowFlags_NoBringToFrontOnFocus) | Im(ImGuiWindowFlags_NoNavFocus)
        }
        
        // When using ImGuiDockNodeFlags_PassthruCentralNode, DockSpace() will render our background
        // and handle the pass-thru hole, so we ask Begin() to not render a background.
        if (dockspaceFlags & Im(ImGuiDockNodeFlags_PassthruCentralNode)) != 0 {
            windowFlags |= Im(ImGuiWindowFlags_NoBackground)
        }
        
        // Important: note that we proceed even if Begin() returns false (aka window is collapsed).
        // This is because we want to keep our DockSpace() active. If a DockSpace() is inactive,
        // all active windows docked into it will lose their parent and become undocked.
        // We cannot preserve the docking relationship between an active window and an inactive docking, otherwise
        // any change of dockspace/settings would lead to windows being stuck in limbo and never being visible.
        ImGuiPushStyleVar(Im(ImGuiStyleVar_WindowPadding), ImVec2(0, 0))
        ImGuiBegin("DockSpace Demo", &dockspaceOpen, windowFlags)
        ImGuiPopStyleVar(1)
        
        if optFullscreen {
            ImGuiPopStyleVar(2)
        }
        
        // Submit the DockSpace
        let io = ImGuiGetIO()!
        let style = ImGuiGetStyle()!
        let minWinSizeX = style.pointee.WindowMinSize.x  // backup
        style.pointee.WindowMinSize.x = 350.0  // set min window size for dockspace's windows
        if (io.pointee.ConfigFlags & Im(ImGuiConfigFlags_DockingEnable)) != 0 {
            let dockspaceID = ImGuiGetID("MyDockSpace")
            _ = ImGuiDockSpace(dockspaceID, ImVec2(0, 0), dockspaceFlags, nil)
        }
        style.pointee.WindowMinSize.x = minWinSizeX  // reset
        
        // Popup Booleans
        
        // var openScenePopup: Bool = false
        // var saveSceneAsPopup: Bool = false
        
        drawMenuBar()
        
        // ImGui Demo
        imGuiDemoPanel.onImGuiRender()
        
        // Scene Panel (Hierarchy Panel + Inspector Panel)
        scenePanel.onImGuiRender()
        
        // Asset Panel
        assetPanel.onImGuiRender()
        
        // Viewport Panel
        viewportPanel.onImGuiRender()
        
        // Console Panel
        consolePanel.onImGuiRender()
        
        ImGuiEnd()  // Docking
    }
    
    override func onEvent(event: Event) {
        viewportPanel.onEvent(event: event)  // editor camera
        
        let dispatcher = EventDispatcher(event: event)
        dispatcher.dispatch(callback: onKeyPressed)
        dispatcher.dispatch(callback: onMouseButtonPressed)
    }
}

// MARK: - Key & Mouse Event Callbacks
extension EditorLayer {
    private func onKeyPressed(event: KeyPressedEvent) -> Bool {
        return true
    }
    
    private func onMouseButtonPressed(event: MouseButtonPressedEvent) -> Bool {
        return true
    }
}

// MARK: - Menu Bar
extension EditorLayer {
    private func drawMenuBar() {
        if ImGuiBeginMenuBar() {
            // File
            if ImGuiBeginMenu("\(FAIcon.file) File", true) {
                // Disabling fullscreen would allow the window to be moved to the front of other windows,
                // which we can't undo at the moment without finer window depth/z control.
                
                if ImGuiMenuItem("\(FAIcon.folderPlus) New", "CMD+N", false, true) { }
                if ImGuiMenuItem("\(FAIcon.folderOpen) Open...", "CMD+O", false, true) { }
                if ImGuiMenuItem("\(FAIcon.save) Save", "CMD+S", false, true) { }
                ImGuiSeparator()
                if ImGuiMenuItem("\(FAIcon.signOutAlt) Exit", "CMD+Q", false, true) { }
                
                /*
                 if (ImGui::MenuItem("New", "Ctrl+N"))
                 NewScene();
                 
                 if (ImGui::MenuItem("Open...", "Cmd+O"))
                 openScenePopup = true;
                 
                 if (ImGui::MenuItem("Save As...", "Cmd+Shift+S"))
                 saveSceneAsPopup = true;
                 
                 if (ImGui::MenuItem("Exit"))
                 Application::Get().Close();
                 */
                
                ImGuiEnd()
            }
            
            // Edit
            if ImGuiBeginMenu("\(FAIcon.edit) Edit", true) {
                if ImGuiMenuItem("\(FAIcon.undo) Undo", "CMD+Z", false, true) { }
                if ImGuiMenuItem("\(FAIcon.redo) Redo", "CMD+Y", false, false) { } // disabled item
                ImGuiSeparator()
                if ImGuiMenuItem("\(FAIcon.cut) Cut", "CMD+X", false, true) { }
                if ImGuiMenuItem("\(FAIcon.copy) Copy", "CMD+C", false, true) { }
                if ImGuiMenuItem("\(FAIcon.paste) Paste", "CMD+V", false, true) {}
                ImGuiEndMenu()
            }
            
            // GameObject
            if ImGuiBeginMenu("\(FAIcon.cube) GameObject", true) {
                scenePanel.drawGameObjectCreationMenuItems()
                ImGuiEndMenu()
            }
            
            // Window
            if ImGuiBeginMenu("\(FAIcon.windowRestore) Window", true) { ImGuiEndMenu() }
            
            // Help
            if ImGuiBeginMenu("\(FAIcon.questionCircle) Help", true) { ImGuiEndMenu() }
            
            ImGuiEndMenuBar()
        }
    }
}
