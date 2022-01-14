//
//  Component+Tag.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

public class TagComponent: Component {
    public var title: String { "Tag" }
    
    public enum Tag: Int {
        case `default` = 0
        case player    = 1
        case enemy     = 2
        case light     = 3
        case camera    = 4
        case script    = 5
        case skybox    = 6
        
        public static let tagStrings: [String] = [
            "Default", "Player", "Enemy", "Light", "Camera", "Script", "Skybox"
        ]
        public static var tagStringsWithIcon: [String] {
            return tagStrings.map { "\(FAIcon.tag) \($0)" }
        }
    }
    
    public var tag: Tag = .default
    
    public required init() {
        
    }
}
