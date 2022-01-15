//
//  ImGuizmo+Enum.swift
//  Palico
//
//  Created by Junhao Wang on 1/14/22.
//

public enum ImGuizmoType: Int {
    case none      = -1
    case translate = 0
    case rotate    = 1
    case scale     = 2
    case bounds    = 3
}

public enum ImGuizmoMode: Int {
    case local = 0
    case world = 1
}
