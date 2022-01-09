//
//  Panel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico

protocol Panel: AnyObject {
    var panelName: String { get }
    
    func onAttach()
    func onUpdate(deltaTime ts: Timestep)
    func onImGuiRender()
    func onEvent(event: Event)
}

// Optional
extension Panel {
    func onAttach() {
        
    }
    
    func onUpdate(deltaTime ts: Timestep) {
        
    }
    
    func onEvent(event: Event) {
        
    }
}
