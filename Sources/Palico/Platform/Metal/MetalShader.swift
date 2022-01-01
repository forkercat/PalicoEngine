//
//  MetalShader.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

import Metal

class MetalShader: Shader {
    let name: String
    let filepath: String
    var source: String? = nil
    var isCompiled: Bool = false
    
    required init(name: String, url: URL) {
        self.name = name
        self.filepath = url.path
        
        do {
            let source = try String(contentsOf: url)
            self.source = source
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }
    
    required init(name: String, source: String) {
        self.name = name
        self.filepath = ""
        self.source = source
    }
}

extension MetalShader {
    static func compile(source: String) {
        do {
            let library = try MetalContext.device.makeLibrary(source: source, options: nil)
            MetalContext.updateShaderLibrary(library)
        } catch let error {
            assertionFailure("Failed shader compilation: \(error.localizedDescription)")
        }
    }
}
