//
//  Component+Script.swift
//  Palico
//
//  Created by Junhao Wang on 1/13/22.
//

public class ScriptComponent: Component {
    public var title: String { "Script" }
    public var enabled: Bool = true
    public static var icon: String { FAIcon.code }
    
    public var nativeScript: NativeScript? = nil
    
    public required init() {
        
    }
    
    public init(_ nativeScript: NativeScript) {
        self.nativeScript = nativeScript
    }
}
