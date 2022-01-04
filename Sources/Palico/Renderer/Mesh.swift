//
//  Mesh.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MetalKit

enum PrimitiveType {
    case cube
    case sphere
    case plane
    case cylinder
}

class MeshFactory {
    static var meshCache: [PrimitiveType: Mesh] = [:]
    
    static func getPrimitiveMesh(type: PrimitiveType) -> Mesh {
        if let mesh = meshCache[type] {
            return mesh
        }
        
        let newMesh = Mesh(type: type)
        meshCache[type] = newMesh
        return newMesh
    }
}

class Mesh {
    let nativeMesh: MTKMesh
    let submeshes: [Submesh]
    
    init(type: PrimitiveType) {
        let allocator = MTKMeshBufferAllocator(device: MetalContext.device)
        
        var mdlMesh: MDLMesh? = nil
        
        switch type {
        case .cube:
            mdlMesh = Self.getCubeMesh(allocator)
        case .sphere:
            mdlMesh = Self.getSphereMesh(allocator)
        case .plane:
            mdlMesh = Self.getPlaneMesh(allocator)
        default:
            mdlMesh = nil
        }
        
        assert(mdlMesh != nil, "Unknown primitive type!")
                
        do {
            let mtkMesh = try MTKMesh(mesh: mdlMesh!, device: MetalContext.device)
            nativeMesh = mtkMesh
            
            submeshes = mdlMesh?.submeshes?.enumerated().compactMap { index, submesh in
                (submesh as? MDLSubmesh).map {
                    Submesh(submesh: mtkMesh.submeshes[index], mdlSubmesh: $0)
                }
            } ?? []
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

extension Mesh {
    private static func getSphereMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(sphereWithExtent: [1, 1, 1],
                       segments: [100, 100],
                       inwardNormals: false,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func getCubeMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(boxWithExtent: [1, 1, 1],
                       segments: [1, 1, 1],
                       inwardNormals: false,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func getPlaneMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(planeWithExtent: [1, 1, 1],
                       segments: [1, 1],
                       geometryType: .triangles,
                       allocator: allocator)
    }
}

extension Mesh {
    static var defaultVertexDescriptor: MDLVertexDescriptor = {
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float3,
                                                            offset: 0,
                                                            bufferIndex: 0)
        vertexDescriptor.attributes[1] = MDLVertexAttribute(name: MDLVertexAttributeNormal,
                                                            format: .float3,
                                                            offset: 12,
                                                            bufferIndex: 0)
        vertexDescriptor.attributes[2] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                                                            format: .float2,
                                                            offset: 24,
                                                            bufferIndex: 0)
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: 32)
        return vertexDescriptor
    }()
}

class Submesh {
    let nativeSubmesh: MTKSubmesh
    
    init(submesh: MTKSubmesh, mdlSubmesh: MDLSubmesh) {
        self.nativeSubmesh = submesh
    }
}
