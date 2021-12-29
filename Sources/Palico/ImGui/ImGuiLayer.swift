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
        setFonts()
        
        // ImGui Style
        ImGuiStyleColorsDark(nil)
        setThemeColors()
        
        // Setup Platform/Renderer Bindings
        ImGuiBackend.implPlatformInit()
        ImGuiBackend.implGraphicsInit()
    }
    
    private func setFonts() {
        let io = ImGuiGetIO()!
        
        let dpi: Float = GraphicsContext.dpi
        let fontSize = Float(18.0)
        let scaledFontSize = Float(dpi * fontSize)
        io.pointee.FontGlobalScale = 1 / dpi
        
        /*
        let robotoRegular = FileUtils.getURL(path: "Assets/Fonts/Roboto/Roboto-Regular.ttf").path  // Roboto
         */
        let openSansBold = FileUtils.getURL(path: "Assets/Fonts/OpenSans/OpenSans-Bold.ttf").path
        let openSansRegular = FileUtils.getURL(path: "Assets/Fonts/OpenSans/OpenSans-Regular.ttf").path
        
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, openSansBold, scaledFontSize, nil, nil)
        io.pointee.FontDefault = ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, openSansRegular, scaledFontSize, nil, nil)
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
    
    private func setThemeColors() {
        /* TODO */
    }
}
