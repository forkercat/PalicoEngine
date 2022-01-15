//
//  Mesh.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MetalKit

public enum PrimitiveType: Int {
    case cube
    case sphere
    case hemisphere
    case plane
    case capsule
    case cylinder
    case cone
    
    public static let typeStrings: [String] = [
        "Cube", "Sphere", "Hemisphere", "Plane", "Capsule", "Cylinder", "Cone"
    ]
}

class MeshFactory {
    static var meshCache: [PrimitiveType: Mesh] = [:]
    
    static func makePrimitiveMesh(type: PrimitiveType) -> Mesh {
        if let mesh = meshCache[type] {
            return mesh
        }
        
        let newMesh = Mesh(type: type)
        meshCache[type] = newMesh
        return newMesh
    }
}

public class Mesh {
    public let nativeMesh: MTKMesh
    let submeshes: [Submesh]
    
    init(type: PrimitiveType) {
        let allocator = MTKMeshBufferAllocator(device: MetalContext.device)
        
        var mdlMesh: MDLMesh
        
        switch type {
        case .cube:
            mdlMesh = Self.makeCubeMesh(allocator)
        case .sphere:
            mdlMesh = Self.makeSphereMesh(allocator)
        case .hemisphere:
            mdlMesh = Self.makeHemiSphereMesh(allocator)
        case .plane:
            mdlMesh = Self.makePlaneMesh(allocator)
        case .capsule:
            mdlMesh = Self.makeCapsule(allocator)
        case .cylinder:
            mdlMesh = Self.makeCylinderMesh(allocator)
        case .cone:
            mdlMesh = Self.makeConeMesh(allocator)
        }
                
        do {
            let mtkMesh = try MTKMesh(mesh: mdlMesh, device: MetalContext.device)
            nativeMesh = mtkMesh
            
            submeshes = mdlMesh.submeshes?.enumerated().compactMap { index, submesh in
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
    private static func makeCubeMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(boxWithExtent: [1, 1, 1],
                       segments: [1, 1, 1],
                       inwardNormals: false,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makeSphereMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(sphereWithExtent: [0.5, 0.5, 0.5],  // radius
                       segments: [50, 50],
                       inwardNormals: false,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makeHemiSphereMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(hemisphereWithExtent: [0.5, 0.5, 0.5],
                       segments: [50, 50],
                       inwardNormals: false,
                       cap: true,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makePlaneMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(planeWithExtent: [1, 1, 1],
                       segments: [1, 1],
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makeCapsule(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(capsuleWithExtent: [0.5, 2, 0.5],
                       cylinderSegments: [50, 50],
                       hemisphereSegments: 50,
                       inwardNormals: false,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makeCylinderMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(cylinderWithExtent: [0.5, 1, 0.5],
                       segments: [50, 50],
                       inwardNormals: false,
                       topCap: true,
                       bottomCap: true,
                       geometryType: .triangles,
                       allocator: allocator)
    }
    
    private static func makeConeMesh(_ allocator: MTKMeshBufferAllocator) -> MDLMesh {
        return MDLMesh(coneWithExtent: [1, 1, 1],
                       segments: [50, 50],
                       inwardNormals: false,
                       cap: true,
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
