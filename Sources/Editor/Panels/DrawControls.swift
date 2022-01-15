//
//  DrawControls.swift
//  Editor
//
//  Created by Junhao Wang on 1/15/22.
//

import Palico
import ImGui
import MathLib

func drawControlFloat3(_ label: String, _ values: inout Float3, _ format: String = "%.1f", _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiPushMultiItemsWidths(3, ImGuiCalcItemWidth())
    
    let itemInnerSpacing: Float = 4
    let itemOutterSpacing: Float = 4
    
    // X
    if ImGuiButton("X", ImVec2(0, 0)) {
        values.x = resetValue
    }
    ImGuiSameLine(0, itemInnerSpacing)
    ImGuiDragFloat("##X", &values.x, 0.1, 0.0, 0.0, format, 0)
    ImGuiPopItemWidth()
    ImGuiSameLine(0, itemOutterSpacing)
    
    // Y
    if ImGuiButton("Y", ImVec2(0, 0)) {
        values.y = resetValue
    }
    ImGuiSameLine(0, itemInnerSpacing)
    ImGuiDragFloat("##Y", &values.y, 0.1, 0.0, 0.0, format, 0)
    ImGuiPopItemWidth()
    ImGuiSameLine(0, itemOutterSpacing)
    
    // Z
    if ImGuiButton("Z", ImVec2(0, 0)) {
        values.z = resetValue
    }
    ImGuiSameLine(0, itemInnerSpacing)
    ImGuiDragFloat("##Z", &values.z, 0.1, 0.0, 0.0, format, 0)
    ImGuiPopItemWidth()
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlFloat2(_ label: String, _ values: inout Float2, _ format: String = "%.1f", _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiPushMultiItemsWidths(2, ImGuiCalcItemWidth())
    
    let itemInnerSpacing: Float = 4
    let itemOutterSpacing: Float = 4
    
    // X
    if ImGuiButton("X", ImVec2(0, 0)) {
        values.x = resetValue
    }
    ImGuiSameLine(0, itemInnerSpacing)
    ImGuiDragFloat("##X", &values.x, 0.1, 0.0, 0.0, format, 0)
    ImGuiPopItemWidth()
    ImGuiSameLine(0, itemOutterSpacing)
    
    // Y
    if ImGuiButton("Y", ImVec2(0, 0)) {
        values.y = resetValue
    }
    ImGuiSameLine(0, itemInnerSpacing)
    ImGuiDragFloat("##Y", &values.y, 0.1, 0.0, 0.0, format, 0)
    ImGuiPopItemWidth()
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlFloat(_ label: String, _ value: inout Float, _ format: String = "%.1f", _ resetValue: Float = 0.0, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiPushMultiItemsWidths(1, ImGuiCalcItemWidth())
    
    ImGuiDragFloat("##X", &value, 0.1, 0.0, 1.0, format, 0)
    ImGuiPopItemWidth()
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlFloatSlider(_ label: String, _ value: inout Float, _ format: String = "%.1f", _ min: Float, _ max: Float, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
    ImGuiSliderFloat("##X", &value, min, max, format, 0)
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlColorEdit3(_ label: String, _ color: inout Color3, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
    ImGuiColorEdit3("##Color3", &color, Im(ImGuiColorEditFlags_None))
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlColorEdit4(_ label: String, _ color: inout Color4, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
    ImGuiColorEdit4("##Color4", &color, Im(ImGuiColorEditFlags_None))
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}

func drawControlCombo(_ label: String, _ selection: inout Int32, _ comboList: [String] , _ columnWidth: Float = 100.0) -> Bool {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
    let changed: Bool = ImGuiCombo("##Combo", &selection, comboList, Int32(comboList.count), -1)
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
    
    return changed
}

func drawControlInputReadOnly(_ label: String, _ input: inout String?, _ columnWidth: Float = 100.0) {
    ImGuiPushID(label)
    ImGuiColumns(2, nil, false)
    
    ImGuiSetColumnWidth(0, columnWidth)
    ImGuiTextV(label)
    ImGuiNextColumn()
    
    ImGuiSetNextItemWidth(-Float.leastNormalMagnitude)
    if ImGuiInputText("##Input", &input, 50, Im(ImGuiInputTextFlags_EnterReturnsTrue) | Im(ImGuiInputTextFlags_ReadOnly), { a -> Int32 in
        return 1
    }, nil) { print(input ?? "") }
    
    ImGuiColumns(1, nil, false)
    ImGuiPopID()  // pop ID label
}
