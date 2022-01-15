//
//  ImGuiLayer.swift
//  Palico
//
//  Created by Junhao Wang on 12/22/21.
//

import ImGui
import ImGuizmo

class ImGuiLayer: Layer {
    // Determine if the events are dispatched to subsequent layers.
    var tryToBlockEvents: Bool = true
    
    override init() {
        super.init(name: "ImGui Layer")
    }
    
    override func onAttach() {
        ImGuiBackend.initialize()
        
        Console.debug("ImGui Version: \(ImGuiGetVersion() ?? "unknown")")
        
        // ImGui Context
        IMGUI_CHECKVERSION()
        _ = ImGuiCreateContext(nil)
        
        let io = ImGuiGetIO()!
        /*
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_NavEnableKeyboard)
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_NavEnableGamepad)
         */
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_DockingEnable)
        io.pointee.ConfigFlags |= Im(ImGuiConfigFlags_ViewportsEnable)
        
        // ImGui Font
        setFonts()
        
        // ImGui Style
        setStyles()
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
        if tryToBlockEvents {
            let io = ImGuiGetIO()!
            
            let mouse = EventUtils.isInCategory(event: event, category: [.mouse]) && io.pointee.WantCaptureMouse
            event.handled = event.handled || mouse
            
            let keyboard = EventUtils.isInCategory(event: event, category: [.keyboard]) && io.pointee.WantCaptureKeyboard
            event.handled = event.handled || keyboard
        }
        // Otherwise: evnets are not handled by ImGui
    }
    
    func begin() {
        ImGuiBackend.implGraphicsNewFrame()
        ImGuiBackend.implPlatformNewFrame()
        ImGuiNewFrame()
        
        // ImGuizmo
        ImGuizmoBeginFrame()
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
    
    private static var iconRanges: [ImWchar] = [0xe00f, 0xf8ff, 0]
    private static var config: ImFontConfig = ImFontConfig_ImFontConfig().pointee  // don't use ImFontConfig()
    
    private func setFonts() {
        let io = ImGuiGetIO()!
        
        let dpi: Float = MetalContext.dpi
        let fontSize = Float(17.0)
        let scaledFontSize = Float(dpi * fontSize)
        let iconFontSize = Float(12.0)
        let iconScaledFontSize = Float(dpi * iconFontSize)
        io.pointee.FontGlobalScale = 1 / dpi
        
        guard let fontBold = FileUtils.getURL(path: "Assets/Fonts/Ruda/Ruda-Bold.ttf")?.path,
              // let fontRegular = FileUtils.getURL(path: "Assets/Fonts/Ruda/Ruda-SemiBold.ttf")?.path,
              let fontSolidIcon = FileUtils.getURL(path: "Assets/Fonts/FontAwesome5/fa-solid-900.ttf")?.path,
              let fontRegularIcon = FileUtils.getURL(path: "Assets/Fonts/FontAwesome5/fa-regular-400.ttf")?.path,
              let fontBrandsIcon = FileUtils.getURL(path: "Assets/Fonts/FontAwesome5/fa-brands-400.ttf")?.path
        else {
            Log.warn("Not able to load custom fonts.")
            return
        }
        
        io.pointee.FontDefault = ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontBold, scaledFontSize, nil, nil)
        ImGuiFontLibrary.defaultFont = io.pointee.FontDefault
        
        // FontAwesome5
        Self.config.MergeMode = true
        Self.config.GlyphMinAdvanceX = scaledFontSize  // Use if you want to make the icon monospaced
        ImGuiFontLibrary.regularIcon = ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontSolidIcon, iconScaledFontSize, &Self.config, &Self.iconRanges)
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontRegularIcon, iconScaledFontSize, &Self.config, &Self.iconRanges)
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontBrandsIcon, iconScaledFontSize, &Self.config, &Self.iconRanges)
        
        // Large Icons
        let largeScale: Float = 1.8
        Self.config.MergeMode = false
        ImGuiFontLibrary.largeIcon = ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontSolidIcon, iconScaledFontSize * largeScale, &Self.config, &Self.iconRanges)
        Self.config.MergeMode = true
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontRegularIcon, iconScaledFontSize * largeScale, &Self.config, &Self.iconRanges)
        ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontBrandsIcon, iconScaledFontSize * largeScale, &Self.config, &Self.iconRanges)
        
        // ImFontAtlas_AddFontFromFileTTF(io.pointee.Fonts, fontRegular, scaledFontSize, nil, nil)
    }
    
    private func setStyles() {
        let style = ImGuiGetStyle()!
        
        ImGuiStyleColorsDark(nil)
        
        // Rounding
        style.pointee.WindowRounding = 4.0
        style.pointee.ChildRounding = 4.0
        style.pointee.FrameRounding = 4.0
        style.pointee.TabRounding = 4.0
        style.pointee.PopupRounding = 4.0
        style.pointee.GrabRounding = 3.0
        
        // Padding
        style.pointee.FramePadding = ImVec2(6, 3)
        
        // Size
        style.pointee.GrabMinSize = 11.0
        
        // Show/Hide
        style.pointee.WindowMenuButtonPosition = Im(ImGuiDir_Right)
        
        /*
         let style = ImGuiGetStyle()!
         if (io.pointee.ConfigFlags & Im(ImGuiConfigFlags_ViewportsEnable)) != 0 {
             style.pointee.WindowRounding = 0.0
             CArray<ImVec4>.write(&style.pointee.Colors) { colors in
                 colors[Int(Im(ImGuiCol_WindowBg))].w = 1.0
             }
         }
         */
    }
    
    private func setThemeColors() {
        ImGui.CArray<ImVec4>.write(&ImGuiGetStyle().pointee.Colors) { colors in
            colors[Int(Im(ImGuiCol_WindowBg))]            = ImVec4(0.1, 0.105, 0.11, 1.0)
            
            // Headers
            colors[Int(Im(ImGuiCol_Header))]              = ImVec4(0.2, 0.205, 0.21, 1.0)
            colors[Int(Im(ImGuiCol_HeaderHovered))]       = ImVec4(0.3, 0.305, 0.31, 1.0)
            colors[Int(Im(ImGuiCol_HeaderActive))]        = ImVec4(0.15, 0.1505, 0.151, 1.0)
            
            // Buttons
            colors[Int(Im(ImGuiCol_Button))]              = ImVec4(0.2, 0.205, 0.21, 1.0)
            colors[Int(Im(ImGuiCol_ButtonHovered))]       = ImVec4(0.3, 0.305, 0.31, 1.0)
            colors[Int(Im(ImGuiCol_ButtonActive))]        = ImVec4(0.15, 0.1505, 0.151, 1.0)
            
            // Frame BG
            colors[Int(Im(ImGuiCol_FrameBg))]             = ImVec4(0.2, 0.205, 0.21, 1.0)
            colors[Int(Im(ImGuiCol_FrameBgHovered))]      = ImVec4(0.3, 0.305, 0.31, 1.0)
            colors[Int(Im(ImGuiCol_FrameBgActive))]       = ImVec4(0.15, 0.1505, 0.151, 1.0)
            
            // Tabs
            colors[Int(Im(ImGuiCol_Tab))]                 = ImVec4(0.15, 0.1505, 0.151, 1.0)
            colors[Int(Im(ImGuiCol_TabHovered))]          = ImVec4(0.38, 0.3805, 0.381, 1.0)
            colors[Int(Im(ImGuiCol_TabActive))]           = ImVec4(0.28, 0.2805, 0.281, 1.0)
            colors[Int(Im(ImGuiCol_TabUnfocused))]        = ImVec4(0.15, 0.1505, 0.151, 1.0)
            colors[Int(Im(ImGuiCol_TabUnfocusedActive))]  = ImVec4(0.2, 0.205, 0.21, 1.0)
            
            // Title
            colors[Int(Im(ImGuiCol_TitleBg))]             = ImVec4(0.15, 0.1505, 0.151, 1.0)
            colors[Int(Im(ImGuiCol_TitleBgActive))]       = ImVec4(0.15, 0.1505, 0.151, 1.0)
            colors[Int(Im(ImGuiCol_TitleBgCollapsed))]    = ImVec4(0.15, 0.1505, 0.151, 1.0)
        }
    }
}
