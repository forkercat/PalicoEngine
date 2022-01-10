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
    let hierarchyPanel: HierarchyPanel = HierarchyPanel()
    let assetPanel: AssetPanel = AssetPanel()
    let viewportPanel: ViewportPanel = ViewportPanel()
    let inspectorPanel: InspectorPanel = InspectorPanel()
    let consolePanel: ConsolePanel = ConsolePanel()
    let imGuiDemoPanel: ImGuiDemoPanel = ImGuiDemoPanel()
    
    // Scene
    var scene: Scene? = nil
    
    override init() {
        super.init()
    }
    
    override init(name: String = "Editor Layer") {
        super.init(name: name)
    }
    
    override func onAttach() {
        // EditorCamera
        viewportPanel.onAttach()
        
        // Scene
        scene = Scene()
        
        // Primitives
        let cube = Cube(name: "Cube", position: [0, 0, 0])
        let cubeMeshRenderer: MeshRendererComponent = cube.getComponent()!
        cubeMeshRenderer.tintColor = .yellow
        
        let sphere = Sphere(name: "Sphere",
                            position: [-6, 1.5, -4], rotation: [0, 0, 0], scale: [1.5, 1.5, 1.5])
        let capsule = Capsule(name: "Capsule",
                              position: [-0.5, 1, -4])
        let capsuleMeshRenderer: MeshRendererComponent = capsule.getComponent()!
        capsuleMeshRenderer.tintColor = .green
        let cone = Cone(name: "Cone",
                        position: [0, 1, 0], rotation: [0, 0, 0], scale: [0.8, 1, 0.8])
        let coneMeshRenderer: MeshRendererComponent = cone.getComponent()!
        coneMeshRenderer.tintColor = .red
        
        let cylinder = Cylinder(name: "Cyliner",
                                position: [-4, 0.5, 0.5], rotation: [0, 0, 0], scale: [1, 1.5, 1])
        let cylinderMeshRenderer: MeshRendererComponent = cylinder.getComponent()!
        cylinderMeshRenderer.tintColor = .lightBlue
        
        scene?.addGameObject(cube)
        scene?.addGameObject(sphere)
        scene?.addGameObject(capsule)
        scene?.addGameObject(cone)
        scene?.addGameObject(cylinder)
        
        // Light Data
        let ambientLight = SceneLight(name: "AmbientLight", type: .ambientLight, position: [5, 5, -5])
        let dirLight = SceneLight(name: "DirLight", type: .dirLight, position: [3, 3, -1])
        let pointLight1 = SceneLight(name: "PointLight1", type: .pointLight, position: [4, 2, 1.5])
        let pointLight2 = SceneLight(name: "PointLight2", type: .pointLight, position: [-3, 4, 1.5])
        
        // Config
        let ambientLightTransform: TransformComponent = ambientLight.getComponent()!
        ambientLightTransform.position = [5, 5, -5]
        
        let dirLightComponent: LightComponent = dirLight.getComponent()!
        dirLightComponent.light.intensity = 0.6
        dirLightComponent.light.color = .lightYellow
        
        let ambientLightComponent: LightComponent = ambientLight.getComponent()!
        ambientLightComponent.light.intensity = 0.2
        
        let pointLightComponent1: LightComponent = pointLight1.getComponent()!
        pointLightComponent1.light.intensity = 0.5
        pointLightComponent1.light.color = .lightBlue
        
        let pointLightComponent2: LightComponent = pointLight2.getComponent()!
        pointLightComponent2.light.intensity = 0.2
        pointLightComponent2.light.color = .red
        
        scene?.addGameObjects([ambientLight, dirLight, pointLight1, pointLight2])
    }
    
    override func onDetach() {
        
    }
    
    override func onUpdate(deltaTime ts: Timestep) {
        // Resize
        if viewportPanel.checkIfViewportNeedsResize() {
            // TODO: resize active scene
            
        }
        
        // onUpdate
        viewportPanel.onUpdate(deltaTime: ts)
        hierarchyPanel.onUpdate(deltaTime: ts)
        
        // Update Scene (Editor)
        scene?.onUpdateEditor(deltaTime: ts)
        
        // Render Scene (Editor)
        scene?.onRenderEditor(deltaTime: ts, editorCamera: viewportPanel.editorCamera)
        
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
        
        if ImGuiBeginMenuBar() {
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
            
            if ImGuiBeginMenu("\(FAIcon.edit) Edit", true) {
                if ImGuiMenuItem("\(FAIcon.undo) Undo", "CMD+Z", false, true) { }
                if ImGuiMenuItem("\(FAIcon.redo) Redo", "CMD+Y", false, false) { } // disabled item
                ImGuiSeparator()
                if ImGuiMenuItem("\(FAIcon.cut) Cut", "CMD+X", false, true) { }
                if ImGuiMenuItem("\(FAIcon.copy) Copy", "CMD+C", false, true) { }
                if ImGuiMenuItem("\(FAIcon.paste) Paste", "CMD+V", false, true) {}
                ImGuiEndMenu()
            }
            
            if ImGuiBeginMenu("\(FAIcon.cube) GameObject", true) { ImGuiEndMenu() }
            if ImGuiBeginMenu("\(FAIcon.windowRestore) Window", true) { ImGuiEndMenu() }
            if ImGuiBeginMenu("\(FAIcon.questionCircle) Help", true) { ImGuiEndMenu() }
            
            ImGuiEndMenuBar()
        }
        
        // ImGui Demo
        imGuiDemoPanel.onImGuiRender()
        
        // Hierarchy Panel
        // TODO: Remove
        hierarchyPanel.onImGuiRender(items: scene?.debugItems ?? [])
        
        // Inspector Panel
        inspectorPanel.onImGuiRender()
        
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

// Key & Mouse Event Callbacks
extension EditorLayer {
    private func onKeyPressed(event: KeyPressedEvent) -> Bool {
        return true
    }
    
    private func onMouseButtonPressed(event: MouseButtonPressedEvent) -> Bool {
        return true
    }
}
