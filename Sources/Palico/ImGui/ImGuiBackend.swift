//
//  ImGuiContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import ImGui

protocol ImGuiBackendPlatformDelegate {
    func implPlatformInit()
    func implPlatformNewFrame()
    func implPlatformShutdown()
}

protocol ImGuiBackendGraphicsDelegate {
    func implGraphicsInit()
    func implGraphicsNewFrame()
    func implGraphicsShutdown()
    func implGraphicsRenderDrawData(_ drawData: ImDrawData)
}

public struct ImGuiBackend {
    private static var platformDelegate: ImGuiBackendCocoaPlatform! = nil
    private static var graphicsDelegate: ImGuiBackendMetalGraphics! = nil
    
    private init() { }
    
    public static func initialize() {
        platformDelegate = ImGuiBackendCocoaPlatform()
        graphicsDelegate = ImGuiBackendMetalGraphics()
    }
    
    // Platform
    public static func implPlatformInit() {
        return platformDelegate.implPlatformInit()
    }
    
    public static func implPlatformNewFrame() {
        return platformDelegate.implPlatformNewFrame()
    }
    
    public static func implPlatformShutdown() {
        return platformDelegate.implPlatformShutdown()
    }

    // Graphics
    public static func implGraphicsInit() {
        return graphicsDelegate.implGraphicsInit()
    }
    
    public static func implGraphicsNewFrame() {
        return graphicsDelegate.implGraphicsNewFrame()
    }
    
    public static func implGraphicsShutdown() {
        return graphicsDelegate.implGraphicsShutdown()
    }
    
    public static func implGraphicsRenderDrawData(_ drawData: ImDrawData) {
        return graphicsDelegate.implGraphicsRenderDrawData(drawData)
    }
}
