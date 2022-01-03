//
//  ShaderLibrary.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

import Foundation

public struct ShaderLibrary {
    private static var shaderCache: [String: Shader] = [:]
    public static var shaderCount: Int { get { shaderCache.count } }
    
    public static func makeShader(name: String, url: URL) -> Shader? {
        Log.debug("Making shader -> \(name) (\(url.lastPathComponent))")
        return Shader(name: name, url: url)
    }
    
    public static func makeShader(name: String, source: String) -> Shader? {
        Log.debug("Making shader -> \(name) (source code)")
        return Shader(name: name, source: source)
    }
    
    public static func add(shader: Shader?) {
        guard let shader = shader else {
            assertionFailure("You are adding a nil shader to library. Skipping it!")
            return
        }
        shaderCache[shader.name] = shader
    }
    
    public static func add(name: String, url: URL?) {
        guard let url = url,
              let shader = makeShader(name: name, url: url)
        else {
            Log.warn("You are adding a nil shader to library. Skipping it!")
            return
        }
        add(shader: shader)
    }
    
    public static func add(name: String, source: String) {
        shaderCache[name] = makeShader(name: name, source: source)
    }
    
    public static func get(name: String) -> Shader? {
        return shaderCache[name]
    }
    
    public static func compileAll() {
        compileShaders(names: Array(shaderCache.keys))
    }
    
    public static func compileShaders(names: [String]) {
        let nameSet = Set(names)
        
        var shaderSource: String = ""
        for name in nameSet {
            guard let shader = get(name: name) else {
                let message = "Unknown shader name: \(name)"
                assertionFailure(message)
                Log.warn(message)
                continue
            }
            shaderSource.append(contentsOf: "\(shader.source ?? "")\n")
        }
        
        // compile
        Shader.compile(source: shaderSource)
        
        for shader in shaderCache.values {
            shader.isCompiled = true
        }
        
        Log.info("""
                 Compiled \(nameSet.count) shader file(s) \
                 that contain \(MetalContext.library.functionNames.count) function(s): \(MetalContext.library.functionNames)
                 """)
    }
    
    public static func empty() {
        Log.debug("Remove all cached shaders!")
        shaderCache.removeAll(keepingCapacity: true)
    }
    
    private init() { }
}
