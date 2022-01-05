//
//  Panel.swift
//  Editor
//
//  Created by Junhao Wang on 1/4/22.
//

protocol Panel {
    var panelName: String { get }
    
    func onImGuiRender()
}
