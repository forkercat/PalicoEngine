//
//  Layer.swift
//  
//
//  Created by Junhao Wang on 12/15/21.
//

// Layer
open class Layer {
    var debugName: String = "Untitled Layer"
    
    public init() { }
    
    public init(name: String) {
        self.debugName = name
    }
    
    open func onAttach() { }
    open func onDetach() { }
    open func onUpdate(deltaTime: Timestep) { }
    open func onImGuiRender() { }
    open func onEvent(event: Event) { }
}

extension Layer: Equatable {
    public static func ==(lhs: Layer, rhs: Layer) -> Bool {
        return lhs === rhs
    }
}

// LayerStack
class LayerStack {
    private(set) var layers: [Layer] = []
    private var layerInsertIndex = 0
    
    init() { }
    
    deinit {
        layers.forEach { layer in
            layer.onDetach()
        }
    }
    
    func pushLayer(_ layer: Layer) {
        layers.insert(layer, at: layerInsertIndex)
        layerInsertIndex += 1
    }
    
    func popLayer(_ layer: Layer) {
        guard let index = layers.firstIndex(of: layer) else {
            Log.warn("LayerStack::popLayer::Layer not found in the stack!")
            return
        }
        layers.remove(at: index)
        layerInsertIndex -= 1
    }
    
    func pushOverlay(_ overlay: Layer) {
        layers.append(overlay)
    }
    
    func popOverlay(_ overlay: Layer) {
        guard let index = layers.firstIndex(of: overlay) else {
            Log.warn("LayerStack::popOverlay::Overlay not found in the stack!")
            return
        }
        layers.remove(at: index)
    }
}
