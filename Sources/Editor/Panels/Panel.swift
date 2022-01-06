//
//  Panel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

import Palico

protocol Panel {
    var panelName: String { get }
    
    func onAttach()
    func onUpdate(deltaTime ts: Timestep)
    func onImGuiRender()
}

// Optional
extension Panel {
    func onAttach() {
        
    }
    
    func onUpdate(deltaTime ts: Timestep) {
        
    }
}
