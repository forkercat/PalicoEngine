//
//  KeyCode.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

public typealias KeyCode = UInt16

public enum Key: KeyCode {
    // Currently only supports Cocoa framework
    // https://stackoverflow.com/questions/36900825/where-are-all-the-cocoa-keycodes
    
    // Digits
    case d0              = 29
    case d1              = 18
    case d2              = 19
    case d3              = 20
    case d4              = 21
    case d5              = 23
    case d6              = 22
    case d7              = 26
    case d8              = 28
    case d9              = 25
    
    // Alphabets
    case A               = 0
    case B               = 11
    case C               = 8
    case D               = 2
    case E               = 14
    case F               = 3
    case G               = 5
    case H               = 4
    case I               = 34
    case J               = 38
    case K               = 40
    case L               = 37
    case M               = 46
    case N               = 45
    case O               = 31
    case P               = 35
    case Q               = 12
    case R               = 15
    case S               = 1
    case T               = 17
    case U               = 32
    case V               = 9
    case W               = 13
    case X               = 7
    case Y               = 16
    case Z               = 6
    
    case sectionSign     = 10
    case grave           = 50
    case minus           = 27
    case equal           = 24
    case leftBracket     = 33
    case RightBracket    = 30
    case Semicolon       = 41
    case quote           = 39
    case comma           = 43
    case period          = 47
    case slash           = 44
    case backslash       = 42
    
    case keypad0         = 82
    case keypad1         = 83
    case keypad2         = 84
    case keypad3         = 85
    case keypad4         = 86
    case keypad5         = 87
    case keypad6         = 88
    case keypad7         = 89
    case keypad8         = 91
    case keypad9         = 92
    case keypadDecimal   = 65
    case keypadMultiply  = 67
    case keypadPlus      = 69
    case keypadDivide    = 75
    case keypadMinus     = 78
    case keypadEquals    = 81
    case keypadClear     = 71
    case keypadEnter     = 76
    
    case space           = 49
    case enter           = 36  /* return */
    case tab             = 48
    case delete          = 51
    case forwardDelete   = 117
    case linefeed        = 52
    case escape          = 53
    
    // Modifiers
    case command         = 55
    case shift           = 56
    case capsLock        = 57
    case option          = 58
    case control         = 59
    case rightShift      = 60
    case rightOption     = 61
    case rightControl    = 62
    case function        = 63
    
    case f1              = 122
    case f2              = 120
    case f3              = 99
    case f4              = 118
    case f5              = 96
    case f6              = 97
    case f7              = 98
    case f8              = 100
    case f9              = 101
    case f10             = 109
    case f11             = 103
    case f12             = 111
    case f13             = 105
    case f14             = 107
    case f15             = 113
    case f16             = 106
    case f17             = 64
    case f18             = 79
    case f19             = 80
    case f20             = 90
    
    case volumeUp        = 72
    case volumeDown      = 73
    case mute            = 74
    case insert          = 114  /* help */
    case home            = 115
    case end             = 119
    case pageUp          = 116
    case pageDown        = 121
    case leftArrow       = 123
    case rightArrow      = 124
    case downArrow       = 125
    case upArrow         = 126
    
    case unknown         = 199
}

extension Key {
    static let maxKeyCode = 200
}
