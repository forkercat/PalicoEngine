//
//  FramebufferDescriptor.swift
//  Palico
//
//  Source: imgui_impl_metal.swift
//
//  Created by Junhao Wang on 12/27/21.
//

import Metal

// An object that encapsulates the data necessary to uniquely identify a
// render pipeline state. These are used as cache keys.
//struct FramebufferDescriptor {
//    let sampleCount: Int
//    let colorPixelFormat: MTLPixelFormat
//    let depthPixelFormat: MTLPixelFormat
//    let stencilPixelFormat: MTLPixelFormat
//    
//    init(_ renderPassDescriptor: MTLRenderPassDescriptor) {
//        sampleCount = renderPassDescriptor.colorAttachments[0].texture!.sampleCount
//        colorPixelFormat = renderPassDescriptor.colorAttachments[0].texture!.pixelFormat
//        depthPixelFormat = renderPassDescriptor.depthAttachment.texture?.pixelFormat ?? .invalid
//        stencilPixelFormat = renderPassDescriptor.stencilAttachment.texture?.pixelFormat ?? .invalid
//    }
//}

//extension FramebufferDescriptor: Equatable {
//    static func == (lhs: FramebufferDescriptor, rhs: FramebufferDescriptor) -> Bool {
//        return lhs.sampleCount == rhs.sampleCount &&
//        lhs.colorPixelFormat == rhs.colorPixelFormat &&
//        lhs.depthPixelFormat == rhs.depthPixelFormat &&
//        lhs.stencilPixelFormat == rhs.stencilPixelFormat
//    }
//
//}

//extension FramebufferDescriptor: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(sampleCount)
//        hasher.combine(colorPixelFormat)
//        hasher.combine(depthPixelFormat)
//        hasher.combine(stencilPixelFormat)
//    }
//}

