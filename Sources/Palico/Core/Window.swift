//
//  Window.swift
//  Palico
//
//  Created by Junhao Wang on 12/15/21.
//

struct WindowDescriptor {
    var title: String
    var width: Int
    var height: Int
    
    init(title: String = "Palico Engine", width: Int, height: Int) {
        self.title = title
        self.width = width
        self.height = height
    }
}

/* Conformed by Cocoa, GLFW, etc */
protocol Window: AnyObject {
    var title: String { get }
    var width: Int { get }
    var height: Int { get }
    var isMinimized: Bool { get }
    
    var windowDelegate: WindowDelegate? { get set }
    
    init(descriptor: WindowDescriptor)
}

protocol WindowDelegate: AnyObject {
    func onEvent(event: Event)
    func onUpdate()
}
