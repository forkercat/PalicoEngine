//
//  CocoaWindow+View.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MathLib

extension CocoaWindow {
    func onViewDraw() {
        windowDelegate?.onUpdate()
    }
    
    func onViewResize(size: Int2) {
        let event = WindowViewResizeEvent(size: size)
        publishEvent(event)
    }
}
