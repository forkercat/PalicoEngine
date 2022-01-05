//
//  EditorLayer.swift
//  Editor
//
//  Created by Junhao Wang on 12/15/21.
//

import Palico
import ImGui

// testing
var show_demo_window: Bool = true
var show_another_window: Bool = false
var clear_color: SIMD3<Float> = .init(x: 0.28, y: 0.36, z: 0.5)
var f: Float = 0.0
var counter: Int = 0

fileprivate var dockspaceOpen: Bool = true
fileprivate var optFullscreenPersistent: Bool = true
fileprivate var dockspaceFlags: ImGuiDockNodeFlags = Int32(ImGuiDockNodeFlags_None.rawValue)

class EditorLayer: Layer {
    var cube: GameObject = Cube()
    var sphere: GameObject = Sphere()
    var plane: GameObject = Plane()
    
    // Panels
    let hierarchyPanel: HierarchyPanel = HierarchyPanel()
    let statsPanel: StatsPanel = StatsPanel()
    let viewportPanel: ViewportPanel = ViewportPanel()
    let inspectorPanel: InspectorPanel = InspectorPanel()
    let consolePanel: ConsolePanel = ConsolePanel()
    let imguiDemoPanel: ImGuiDemoPanel = ImGuiDemoPanel()
    
    override init() {
        super.init()
    }
    
    override init(name: String) {
        super.init(name: name)
    }
    
    override func onAttach() {
        
    }
    
    override func onDetach() {
        
    }
    
    override func onUpdate(deltaTime: Timestep) {
        // Resize
        
        
        // Update
        
        // Render
        
        Renderer.beginRenderPass(type: .colorPass, begin: .clear)
        Renderer.render(gameObject: sphere)
        Renderer.endRenderPass()
        
        Renderer.beginRenderPass(type: .colorPass, begin: .keep)
        Renderer.render(gameObject: cube)
        Renderer.endRenderPass()
    }
    
    override func onImGuiRender() {
        let optFullscreen: Bool = optFullscreenPersistent
        dockspaceFlags = Int32(ImGuiDockNodeFlags_None.rawValue)
        
        // We are using the ImGuiWindowFlags_NoDocking flag to make the parent window not dockable into,
        // because it would be confusing to have two docking targets within each others.
        var windowFlags: ImGuiWindowFlags = Int32(ImGuiWindowFlags_MenuBar.rawValue) | Int32(ImGuiWindowFlags_NoDocking.rawValue)
        if optFullscreen {
            let viewport = ImGuiGetMainViewport()!
            ImGuiSetNextWindowPos(viewport.pointee.Pos, Int32(ImGuiCond_None.rawValue), ImVec2(x: 0, y: 0))
            ImGuiSetNextWindowSize(viewport.pointee.Size, Int32(ImGuiCond_None.rawValue))
            ImGuiSetNextWindowViewport(viewport.pointee.ID)
            ImGuiPushStyleVar(Int32(ImGuiStyleVar_WindowRounding.rawValue), 0.0)
            ImGuiPushStyleVar(Int32(ImGuiStyleVar_WindowBorderSize.rawValue), 0.0)
            windowFlags |= Int32(ImGuiWindowFlags_NoTitleBar.rawValue) | Int32(ImGuiWindowFlags_NoCollapse.rawValue) |
                           Int32(ImGuiWindowFlags_NoResize.rawValue) | Int32(ImGuiWindowFlags_NoMove.rawValue)
            windowFlags |= Int32(ImGuiWindowFlags_NoBringToFrontOnFocus.rawValue) | Int32(ImGuiWindowFlags_NoNavFocus.rawValue)
        }
        
        // When using ImGuiDockNodeFlags_PassthruCentralNode, DockSpace() will render our background
        // and handle the pass-thru hole, so we ask Begin() to not render a background.
        if (dockspaceFlags & Int32(ImGuiDockNodeFlags_PassthruCentralNode.rawValue)) != 0 {
            windowFlags |= Int32(ImGuiWindowFlags_NoBackground.rawValue)
        }
        
        // Important: note that we proceed even if Begin() returns false (aka window is collapsed).
        // This is because we want to keep our DockSpace() active. If a DockSpace() is inactive,
        // all active windows docked into it will lose their parent and become undocked.
        // We cannot preserve the docking relationship between an active window and an inactive docking, otherwise
        // any change of dockspace/settings would lead to windows being stuck in limbo and never being visible.
        ImGuiPushStyleVar(Int32(ImGuiStyleVar_WindowPadding.rawValue), ImVec2(x: 0, y: 0))
        ImGuiBegin("DockSpace Demo", &dockspaceOpen, windowFlags)
        ImGuiPopStyleVar(1)
        
        if optFullscreen {
            ImGuiPopStyleVar(2)
        }
        
        // Submit the DockSpace
        let io = ImGuiGetIO()!
        let style = ImGuiGetStyle()!
        let minWinSizeX = style.pointee.WindowMinSize.x  // backup
        style.pointee.WindowMinSize.x = 370.0  // set min window size for dockspace's windows
        if (io.pointee.ConfigFlags & Int32(ImGuiConfigFlags_DockingEnable.rawValue)) != 0 {
            let dockspaceID = ImGuiGetID("MyDockSpace")
            _ = ImGuiDockSpace(dockspaceID, ImVec2(x: 0, y: 0), dockspaceFlags, nil)
        }
        style.pointee.WindowMinSize.x = minWinSizeX  // reset
        
        // Popup Booleans
        
        // var openScenePopup: Bool = false
        // var saveSceneAsPopup: Bool = false
        
        if ImGuiBeginMenuBar() {
            if ImGuiBeginMenu("File", true) {
                // Disabling fullscreen would allow the window to be moved to the front of other windows,
                // which we can't undo at the moment without finer window depth/z control.
                
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
            
            ImGuiEndMenuBar()
        }
        
        // Hierarchy Panel
        hierarchyPanel.onImGuiRender()
        
        // Inspector Panel
        inspectorPanel.onImGuiRender()
        
        // Stats Panel
        statsPanel.onImGuiRender()
        
        // Viewport Panel
        viewportPanel.onImGuiRender()
        
        // ImGui Demo
        imguiDemoPanel.onImGuiRender()
        
        ImGuiEnd()  // Docking
    }
    
    override func onEvent(event: Event) {
        let dispatcher = EventDispatcher(event: event)
        _ = dispatcher.dispatch(callback: onKeyPressed)
        _ = dispatcher.dispatch(callback: onMouseButtonPressed)
    }
    
    private func onKeyPressed(event: KeyPressedEvent) -> Bool {
        return true
    }
    
    private func onMouseButtonPressed(evet: MouseButtonPressedEvent) -> Bool {
        return true
    }
}
