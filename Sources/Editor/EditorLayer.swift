//
//  EditorLayer.swift
//  Editor
//
//  Created by Junhao Wang on 12/15/21.
//

import Palico

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
