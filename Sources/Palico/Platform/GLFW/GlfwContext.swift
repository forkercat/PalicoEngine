//
//  GlfwContext.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import CGLFW3

fileprivate struct GLFWInt32 {
    static var FALSE: Int32 = 0
    static var TRUE: Int32 = 1
}

class GlfwContext: PlatformContextDelegate {
    init() { }
    
    var isAppRunning: Bool { isRunning }
    var isAppActive: Bool { isActive }
    var currentTime: Timestep { glfwGetTime() }
    
    private var isRunning: Bool = false
    private var isActive: Bool = false
    
    func initialize() {
        let success = glfwInit()
        assert(success != 0, "Could not initialize GLFW!")
        glfwSetErrorCallback{ (error: Int32, description: UnsafePointer<CChar>?) in
            let str = String(cString: description!)
            assertionFailure("GLFW Error \(error): \(str)")
        }
        
        glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
        glfwWindowHint(GLFW_RESIZABLE, GLFWInt32.TRUE)  // by default
    }
    
    func activate() {
        isRunning = true
    }
    
    func deinitialize() {
        isRunning = false
        glfwTerminate()
    }
}
