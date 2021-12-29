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
    
    public static func makeShader(name: String, url: URL) -> Shader {
        Log.debug("ShaderLibrary::Making shader -> \(name) (\(url.lastPathComponent))")
        let api = RendererAPI.getAPI()
        switch api {
        case .metal:
            return MetalShader(name: name, url: url)
        default:
            fatalError("API (\(api)) is not supported!")
        }
    }
    
    public static func makeShader(name: String, source: String) -> Shader {
        Log.debug("ShaderLibrary::Making shader -> \(name) (source code)")
        let api = RendererAPI.getAPI()
        switch api {
        case .metal:
            return MetalShader(name: name, source: source)
        default:
            fatalError("API (\(api)) is not supported!")
        }
    }
    
    public static func add(shader: Shader) {
        shaderCache[shader.name] = shader
    }
    
    public static func add(name: String, url: URL) {
        add(shader: makeShader(name: name, url: url))
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
                fatalError("Unknown shader name: \(name)")
            }
            shaderSource.append(contentsOf: "\(shader.source ?? "")\n")
        }
        
        // compile
        let api = RendererAPI.getAPI()
        switch api {
        case .metal:
            MetalShader.compile(source: shaderSource)
        default:
            fatalError("API (\(api)) is not supported!")
        }
        
        for var shader in shaderCache.values {
            shader.isCompiled = true
        }
        
        Log.info("""
                 ShaderLibrary::Compiled \(nameSet.count) shader file(s) \
                 that contain \(MetalContext.library.functionNames.count) function(s): \(MetalContext.library.functionNames)
                 """)
    }
    
    public static func empty() {
        Log.debug("ShaderLibrary::Remove all cached shaders!")
        shaderCache.removeAll(keepingCapacity: true)
    }
    
    private init() { }
}
