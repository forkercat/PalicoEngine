//
//  View.swift
//  Palico
//
//  Created by Junhao Wang on 12/24/21.
//

/* Conformed by Cocoa, GLFW, etc */
protocol View {
    var width:        UInt32 { get }
    var height:       UInt32 { get }
    var viewDelegate: ViewDelegate? { get set }
    
    func setPreferredFPS(as fps: Int)
}

protocol ViewDelegate: AnyObject {
    func viewShouldStartDrawing(in view: View)
    func onViewResize(width: UInt32, height: UInt32)
}
