//
//  EditorCamera.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

public class EditorCamera: Camera {
    // Parameters
    public private(set) var fov: Float         = 45.0
    public private(set) var aspectRatio: Float = 1.778
    public private(set) var nearClip: Float    = 0.1
    public private(set) var farClip: Float     = 1000.0
    public var position: Float3 { get {
        return focusPoint - forwardDirection * distance
    }}
    
    // Orientation
    public var orientation: Quaternion { get {
        // Order matters! We want:
        // 1. Rotation around X-axis behaves like as in local space
        // 2. Rotation around Y-axis behaves like as in world space
        // Thus, rotation order: X -> Y (in quaternion it is inverse)
        return Quaternion(rotaionXYZ: [-pitchAtFocus, yawAtFocus, 0])
        
        // Equivalent:
        // let qx = Quaternion(angle: -pitchAtFocus, axis: Float3.right)
        // let qy = Quaternion(angle: yawAtFocus, axis: Float3.up)
        // return mul(qy, qx)
    }}
    public var rightDirection: Float3 { get {    // X
        return orientation.act(Float3.right)
        
    }}
    public var upDirection: Float3 { get {       // Y
        return orientation.act(Float3.up)
    }}
    public var forwardDirection: Float3 { get {  // Z
        return orientation.act(Float3.forward)
    }}
    
    // Config
    private var rotationSpeed: Float { get {
        0.2
    }}
    private var lookAroundSpeed: Float { get {
        0.1
    }}
    private var zoomSpeed: Float { get {
        let dist = max(distance * 0.15, 0)
        let speed = min(dist * dist, 15)  // max speed is 15
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
    private var focusPoint: Float3           = [0, 1.0, 0]
    private var distance: Float              = 10.0
    private var pitchAtFocus: Float          = Float(-20).toRadians
    private var yawAtFocus: Float            = Float(-135).toRadians  // within [+X, +Y, +Z] 10 away from origin
    private var viewportSize: Int2           = [1280, 720]
    
    // Output
    public private(set) var viewMatrix: Float4x4       = .identity
    public private(set) var projectionMatrix: Float4x4 = .identity
    
    private var initialMousePosition: Float2 = [-1, -1]
    
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
         yaw = 0, pitch = 0
         */
        let R = Float4x4(orientation)
        let T = Float4x4(translation: position)
        viewMatrix = mul(T, R).inverse
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
    
    public func setFocusPoint(_ focusPoint: Float3, _ distance: Float = 10) {
        self.distance = distance
        self.focusPoint = focusPoint
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
        
        guard initialMousePosition.x != -1 else {
            initialMousePosition = mouse
            return
        }
        
        let delta: Float2 = (mouse - initialMousePosition) * ts
        initialMousePosition = mouse
        
        if Input.isPressed(key: .option) || Input.isPressed(key: .command) {
            if Input.isPressed(mouse: .left) {
                rotateAroundFocusPoint(delta: delta)
            }
        }
        
        if Input.isPressed(mouse: .middle) {
            pan(delta: delta)
        }
        
        if Input.isPressed(mouse: .right) {
            lookAround(delta: delta)
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
    
    private func lookAround(delta: Float2) {
        let oldPosition = position
        pitchAtFocus += delta.y * lookAroundSpeed
        yawAtFocus += delta.x * lookAroundSpeed
        focusPoint = oldPosition + forwardDirection * distance
    }
}
