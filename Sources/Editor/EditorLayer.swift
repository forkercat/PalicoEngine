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

class EditorLayer: Layer {
    
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
        
    }
    
    override func onImGuiRender() {
        // 1. Show the big demo window (Most of the sample code is in ImGui::ShowDemoWindow()!
        // You can browse its code to learn more about Dear ImGui!).
        if show_demo_window {
            ImGuiShowDemoWindow(&show_demo_window)
        }
        
        // 2. Show a simple window that we create ourselves. We use a Begin/End pair to created a named window.
        
        // Create a window called "Hello, world!" and append into it.
        ImGuiBegin("Begin", &show_demo_window, 0)
        
        // Display some text (you can use a format strings too)
        ImGuiTextV("This is some useful text.")
        
        // Edit bools storing our window open/close state
        ImGuiCheckbox("Demo Window", &show_demo_window)
        ImGuiCheckbox("Another Window", &show_another_window)
        
        ImGuiSliderFloat("Float Slider", &f, 0.0, 1.0, nil, 1) // Edit 1 float using a slider from 0.0f to 1.0f
        
        ImGuiColorEdit3("clear color", &clear_color, 0) // Edit 3 floats representing a color
        
        if ImGuiButton("Button", ImVec2(x: 100,y: 20)) { // Buttons return true when clicked (most widgets return true when edited/activated)
            counter += 1
        }
        
        //SameLine(offset_from_start_x: 0, spacing: 0)
        
        ImGuiSameLine(0, 2)
        ImGuiTextV(String(format: "counter = %d", counter))
        
        let io = ImGuiGetIO()!
        let avg: Float = (1000.0 / io.pointee.Framerate)
        let fps = io.pointee.Framerate
        
        ImGuiTextV(String(format: "Application average %.3f ms/frame (%.1f FPS)", avg, fps))
        
        ImGuiEnd()
        //End()
        
        // 3. Show another simple window.
        if show_another_window {
            
            ImGuiBegin("Another Window", &show_another_window, 0)  // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
            
            ImGuiTextV("Hello from another window!")
            if ImGuiButton("Close Me", ImVec2(x: 100, y: 20)) {
                show_another_window = false
            }
            ImGuiEnd()
        }
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
