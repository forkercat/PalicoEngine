//
//  ImGuiLayer.swift
//  Palico
//
//  Created by Junhao Wang on 12/22/21.
//

import ImGui
import CImGui

class ImGuiLayer: Layer {
    // Determine if the events are dispatched to subsequent layers.
    var blockEvents: Bool = true
    
    override init() {
        super.init(name: "ImGuiLayer")
    }
    
    override func onAttach() {
        ImGuiBackend.initialize()
        
        // ImGui Context
        IMGUI_CHECKVERSION()
        _ = ImGuiCreateContext(nil)
        
        let io = ImGuiGetIO()!
        io.pointee.ConfigFlags |= Int32(ImGuiConfigFlags_NavEnableKeyboard.rawValue)
        io.pointee.ConfigFlags |= Int32(ImGuiConfigFlags_DockingEnable.rawValue)
        io.pointee.ConfigFlags |= Int32(ImGuiConfigFlags_ViewportsEnable.rawValue)
        
        // ImGui Font
//        let dpi: Float = 2.0
//        let fontSize: Float = 18.0
//        io.pointee.FontGlobalScale = 1 / dpi
        
        // ImGui Style
        ImGuiStyleColorsDark(nil)
        
        // Setup Platform/Renderer Bindings
        ImGuiBackend.implPlatformInit()
        ImGuiBackend.implGraphicsInit()
    }
    
    override func onDetach() {
        ImGuiBackend.implGraphicsShutdown()
        ImGui_ImplMetal_Shutdown()
        ImGuiDestroyContext(nil)
    }
    
    override func onEvent(event: Event) {
        var event = event
        if blockEvents {
            let io = ImGuiGetIO()!
            
            let mouse = EventUtils.isInCategory(event: event, category: [.mouse]) && io.pointee.WantCaptureMouse
            event.handled = event.handled || mouse
            
            let keyboard = EventUtils.isInCategory(event: event, category: [.keyboard]) && io.pointee.WantCaptureKeyboard
            event.handled = event.handled || keyboard
        }
    }
    
    func begin() {
        ImGuiBackend.implGraphicsNewFrame()
        ImGuiBackend.implPlatformNewFrame()
        ImGuiNewFrame()
        
        // ImGuizmo::BeginFrame()
    }
    
    func end() {
        ImGuiRender()
        let drawData = ImGuiGetDrawData()!
        ImGuiBackend.implGraphicsRenderDrawData(drawData.pointee)
        
//        if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
//        {
//            GLFWwindow* backup_current_context = glfwGetCurrentContext();
//            ImGui::UpdatePlatformWindows();
//            ImGui::RenderPlatformWindowsDefault();
//            glfwMakeContextCurrent(backup_current_context);
//        }
    }
}
