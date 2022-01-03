//
//  Mesh.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MetalKit

// Mesh
enum PrimitiveType {
    case triangle
    case cube
    case sphere
    case plane
    case cylinder
}

class MeshFactory {
    
    
    var meshCache: [PrimitiveType: Mesh] = [:]
    
    static func getPrimitiveMesh(type: PrimitiveType) -> Mesh {
        return Mesh()
    }
}


class Mesh {
//    var mesh: Any { get }
//    var submeshes: [Submesh] { get }
}

//class ModelIOMesh: Mesh {
//    var mesh: Any
//    var submeshes: [Submesh]
//
//    init(type: PrimitiveType) {
//        let allocator = MTKMeshBufferAllocator(device: MetalContext.device)
//        let mdlMesh = MDLMesh(sphereWithExtent: [1.0, 1.0, 1.0],
//                              segments: [100, 100, 100],
//                              inwardNormals: false,
//                              geometryType: .triangles,
//                              allocator: allocator)
//        do {
//            let mtkMesh = try MTKMesh(mesh: mdlMesh, device: MetalContext.device)
//            mesh = mtkMesh
//
//            submeshes = mdlMesh.submeshes?.enumerated().compactMap { index, submesh in
//                (submesh as? MDLSubmesh).map {
//                    ModelIOSubmesh(submesh: mtkMesh.submeshes[index], mdlSubmseh: $0)
//                }
//            } ?? []
//        } catch let error {
//            assertionFailure(error.localizedDescription)
//            return
//        }
//    }
//}

class Submesh {
//    var submesh: Any { get }
}

//class ModelIOSubmesh: Submesh {
//    var submesh: Any
//
//    init(submesh: MTKSubmesh, mdlSubmseh: MDLSubmesh) {
//        self.submesh = submesh
//    }
//
//}
