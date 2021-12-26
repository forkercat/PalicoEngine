//
//  Window.swift
//  Palico
//
//  Created by Junhao Wang on 12/15/21.
//

struct WindowDescriptor {
    var title:  String
    var width:  UInt32
    var height: UInt32
    
    init(title: String = "Palico Engine", width: UInt32 = 1280, height: UInt32 = 720) {
        self.title = title
        self.width = width
        self.height = height
    }
}

/* Conformed by Cocoa, GLFW, etc */
protocol Window {
    var title:          String { get }
    var width:          UInt32 { get }
    var height:         UInt32 { get }
    var isMinimized:    Bool { get }
    var view:           View { get }
    
    var windowDelegate: WindowDelegate? { get set }
    
    init(descriptor: WindowDescriptor)
}

protocol WindowDelegate: AnyObject {
    func onUpdate(deltaTime: Timestep, in view: View)
    func onEvent(event: Event)
}
