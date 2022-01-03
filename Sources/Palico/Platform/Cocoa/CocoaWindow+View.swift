//
//  CocoaWindow+View.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

extension CocoaWindow {
    func onViewDraw() {
        windowDelegate?.onUpdate()
    }
    
    func onViewResize(width: UInt32, height: UInt32) {
        let event = WindowViewResizeEvent(width: width, height: height)
        publishEvent(event)
    }
}
