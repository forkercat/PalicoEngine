//
//  EditorCamera.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib
import simd

public class EditorCamera: Camera {
    // Parameters
    public private(set) var fov: Float         = 45.0
    public private(set) var aspectRatio: Float = 1.778
    public private(set) var nearClip: Float    = 0.1
    public private(set) var farClip: Float     = 1000.0
    
    // Orientation
    public var orientation: Quaternion { get {
        return Quaternion(eulerAngles: [-pitchAtFocus, yawAtFocus, 0])
    }}
    public var rightDirection: Float3 { get {
        return orientation.act(Float3.right)
    }}
    public var upDirection: Float3 { get {
        return orientation.act(Float3.up)
    }}
    public var forwardDirection: Float3 { get {
        return orientation.act(Float3.forward)
    }}
    
    // Config
    private var rotationSpeed: Float { get {
        0.2
    }}
    private var zoomSpeed: Float { get {
        let dist = max(distance * 0.2, 0)
        let speed = min(dist * dist, 20)  // max speed is 20
        return speed
    }}
    private var panSpeed: Float2 { get {
        // Source: EditorCamera.cpp in Hazel Engine (by The Cherno)
        // Calculate based on the viewport size
        let x: Float = min(Float(viewportSize.width) / 1000.0, 2.4)   // min = 2.4
        let xFactor: Float = 0.0366 * x * x - 0.1778 * x + 0.3021
        
        let y: Float = min(Float(viewportSize.height) / 1000.0, 2.4)  // min = 2.4
        let yFactor = 0.0366 * y * y - 0.1778 + 0.3021
        
        let scale: Float = 0.4  // change speed
        
        return Float2(xFactor, yFactor) * scale
    }}
    
    // Private
    private var focusPoint: Float3       = Float3(0, 0, 0)
    private var position: Float3         = Float3(0, 0, 0)
    private var distance: Float          = 10.0
    private var pitchAtFocus: Float  = 0.0
    private var yawAtFocus: Float    = 0.0
    private var viewportSize: Int2       = Int2(1280, 720)
    
    // Output
    public private(set) var viewMatrix: Float4x4       = .identity
    public private(set) var projectionMatrix: Float4x4 = .identity
    
    private var initialMousePosition: Float2 = Float2(0, 0)
    
    public init() {
        updateProjection()
        updateView()
    }
    
    public init(fov: Float, aspect: Float, nearClip: Float = 0.1, farClip: Float = 1000.0) {
        self.fov = fov
        self.aspectRatio = aspect
        self.nearClip = nearClip
        self.farClip = farClip
        
        updateProjection()
        updateView()
    }
}

// View and Projection
extension EditorCamera {
    private func updateView() {
        /* Lock camera's orientation
         yaw = 0
         pitch = 0
         */
        position = focusPoint - forwardDirection * distance
        
        let R = Float4x4(orientation)
        let T = Float4x4(translation: position)
        viewMatrix = (T * R).inverse
    }
    
    private func updateProjection() {
        aspectRatio = Float(viewportSize.width) / Float(viewportSize.height)
        projectionMatrix = Float4x4(projectionFov: fov.toRadians,
                                    aspectRatio: aspectRatio,
                                    near: nearClip, far: farClip)
    }
}

// Setter
extension EditorCamera {
    public func setDistance(_ distance: Float) {
        self.distance = distance
        updateView()
    }
    
    public func setFov(_ fov: Float) {
        self.fov = fov
        updateProjection()
    }
    
    public func setViewportSize(_ size: Int2) {
        viewportSize = size
        updateProjection()
    }
}

// Update
extension EditorCamera {
    public func onUpdate(deltaTime ts: Timestep) {
        let mouse: Float2 = Input.mousePos
        let delta: Float2 = (mouse - initialMousePosition) * ts
        initialMousePosition = mouse
        
        if Input.isPressed(key: .option) || Input.isPressed(key: .command) {
            if Input.isPressed(mouse: .left) {
                rotateAroundFocusPoint(delta: delta)
            } else if Input.isPressed(mouse: .right) {
                zoom(delta: delta.y)
            }
        } else if Input.isPressed(mouse: .middle) {
            pan(delta: delta)
        }
        
        updateView()
    }
    
    public func onEvent(event: Event) {
        let dispatcher = EventDispatcher(event: event)
        dispatcher.dispatch(callback: onMouseScroll)
    }
    
    private func onMouseScroll(event: MouseScrolledEvent) -> Bool {
        let delta: Float = event.yoffset * 0.1
        zoom(delta: delta)
        updateView()
        return false
    }
    
    private func pan(delta: Float2) {
        let speed = panSpeed
        // Should be opposite as you pan to other direction
        focusPoint -= rightDirection * delta.x * speed.x * distance
        focusPoint -= upDirection * delta.y * speed.y * distance
    }
    
    private func rotateAroundFocusPoint(delta: Float2) {
        let yawSign: Float = upDirection.y < 0 ? -1.0 : 1.0
        yawAtFocus += yawSign * delta.x * rotationSpeed
        pitchAtFocus += delta.y * rotationSpeed
    }
    
    private func zoom(delta: Float) {
        distance -= delta * zoomSpeed
        if distance < 1.0 {
            focusPoint += forwardDirection
            distance = 1.0
        }
    }
}
