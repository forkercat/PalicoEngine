//
//  ImGuiLayer.swift
//  Palico
//
//  Created by Junhao Wang on 12/22/21.
//

import ImGui

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
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_NavEnableKeyboard)
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_NavEnableGamepad)
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_DockingEnable)
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_ViewportsEnable)
        
        // ImGui Font
        setFonts()
        
        // ImGui Style
        ImGuiStyleColorsDark(nil)
        
        /*
        let style = ImGuiGetStyle()!
        if (io.pointee.ConfigFlags & Im(ImGuiConfigFlags_ViewportsEnable)) != 0 {
            style.pointee.WindowRounding = 0.0
            CArray<ImVec4>.write(&style.pointee.Colors) { colors in
                colors[Im(ImGuiCol_WindowBg)].w = 1.0
            }
        }
         */
        
        setThemeColors()
        
        // Setup Platform/Renderer Bindings
        ImGuiBackend.implPlatformInit()
        ImGuiBackend.implGraphicsInit()
    }
    
    override func onDetach() {
        ImGuiBackend.implGraphicsShutdown()
        ImGuiBackend.implPlatformShutdown()
        ImGuiDestroyContext(ImGuiGetCurrentContext())
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
        
        if (ImGuiGetIO()!.pointee.ConfigFlags & Im(ImGuiConfigFlags_ViewportsEnable)) != 0 {
            ImGuiUpdatePlatformWindows()
            ImGuiRenderPlatformWindowsDefault(nil, nil)
        }
    }
    
    private func setFonts() {
        let io = ImGuiGetIO()!
        
        let dpi: Float = MetalContext.dpi
        let fontSize = Float(18.0)
        let scaledFontSize = Float(dpi * fontSize)
        io.pointee.FontGlobalScale = 1 / dpi
        
        // let robotoRegular = FileUtils.getURL(path: "Assets/Fonts/Roboto/Roboto-Regular.ttf").path  // Roboto
        guard let openSansBold = FileUtils.getURL(path: "Assets/Fonts/OpenSans/OpenSans-Bold.ttf")?.path,
              let openSansRegular = FileUtils.getURL(path: "Assets/Fonts/OpenSans/OpenSans-Regular.ttf")?.path
        else {
            Log.warn("Not able to load custom fonts.")
            return
        }
        
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, openSansBold, scaledFontSize, nil, nil)
        io.pointee.FontDefault = ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, openSansRegular, scaledFontSize, nil, nil)
    }
    
    private func setThemeColors() {
        /* TODO */
    }
}
