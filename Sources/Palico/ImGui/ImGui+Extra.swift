//
//  ImGui+Extra.swift
//  Palico
//
//  Created by Junhao Wang on 1/5/22.
//

import ImGui

public let ImGuiFlag_None: Int32 = 0

public func ImGuiHelpMarker(_ label: String = "", _ string: String = "") {
    ImGuiTextV("\(FAIcon.questionCircle) \(label)")
    if igIsItemHovered(0) {
        ImGuiBeginTooltip()
        ImGuiTextUnformatted(string, nil)
        ImGuiEndTooltip()
    }
}

extension ImVec2 {
    public init(_ v0: Float, _ v1: Float) {
        self.init(x: v0, y: v1)
    }
    
    public init(_ v: Float) {
        self.init(v, v)
    }
}

extension ImVec4 {
    public init(_ v0: Float, _ v1: Float, _ v2: Float, _ v3: Float) {
        self.init(x: v0, y: v1, z: v2, w: v3)
    }
    
    public init(_ v: Float) {
        self.init(v, v, v, v)
    }
}

// Im Functions
@inline(__always) public func Im(_ flag: ImGuiWindowFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiInputTextFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTreeNodeFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiPopupFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSelectableFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiComboFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTabBarFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTabItemFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTableFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTableColumnFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTableRowFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTableBgTarget_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiFocusedFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiHoveredFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDockNodeFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDragDropFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDataType_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDir_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSortDirection_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiKey_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiKeyModFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNavInput_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiConfigFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiBackendFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiCol_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiStyleVar_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiButtonFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiColorEditFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSliderFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiMouseButton_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiMouseCursor_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiCond_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiItemFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiItemStatusFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiInputTextFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiButtonFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiComboFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSliderFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSelectableFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTreeNodeFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiSeparatorFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTextFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTooltipFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiLayoutType_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiLogType) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiAxis) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiPlotType) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiInputSource) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiInputReadMode) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiPopupPositionPolicy) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDataTypePrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNextWindowDataFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNextItemDataFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiActivateFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiScrollFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNavHighlightFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNavDirSourceFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNavMoveFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiNavLayer) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiOldColumnFlags_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDockNodeFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDataAuthority_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiDockNodeState) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiWindowDockStyleCol) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiContextHookType) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTabBarFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}

@inline(__always) public func Im(_ flag: ImGuiTabItemFlagsPrivate_) -> Int32 {
    return Int32(flag.rawValue)
}
