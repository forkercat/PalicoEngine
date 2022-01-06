//
//  RenderPass+Action.swift
//  Palico
//
//  Created by Junhao Wang on 1/5/22.
//

import Metal

public enum RenderPassBeginAction {
    case clear
    case keep
    case dontCare
}

public enum RenderPassEndAction {
    case store
    case dontCare
}

func convertMTLLoadAction(_ action: RenderPassBeginAction) -> MTLLoadAction {
    switch action {
    case .clear:
        return .clear
    case .keep:
        return .load
    case .dontCare:
        return .dontCare
    }
}

func convertMTLStoreAction(_ action: RenderPassEndAction) -> MTLStoreAction {
    switch action {
    case .store:
        return .store
    case .dontCare:
        return .dontCare
    }
}

