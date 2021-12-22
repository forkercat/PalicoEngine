//
//  KeyCode.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

public typealias KeyCode = UInt16
public typealias CharCode = UInt16

public enum Key: KeyCode {
    // From glfw3.h
    case unknown             = 10
    
    case space               = 32
    case apostrophe          = 39  /* ' */
    case comma               = 44  /* , */
    case minus               = 45  /* - */
    case period              = 46  /* . */
    case slash               = 47  /* / */
    
    case digit0              = 48  /* 0 */
    case digit1              = 49  /* 1 */
    case digit2              = 50  /* 2 */
    case digit3              = 51  /* 3 */
    case digit4              = 52  /* 4 */
    case digit5              = 53  /* 5 */
    case digit6              = 54  /* 6 */
    case digit7              = 55  /* 7 */
    case digit8              = 56  /* 8 */
    case digit9              = 57  /* 9 */
    
    case semicolon           = 59  /* ; */
    case equal               = 61  /* = */
    
    case A                   = 65
    case B                   = 66
    case C                   = 67
    case D                   = 68
    case E                   = 69
    case F                   = 70
    case G                   = 71
    case H                   = 72
    case I                   = 73
    case J                   = 74
    case K                   = 75
    case L                   = 76
    case M                   = 77
    case N                   = 78
    case O                   = 79
    case P                   = 80
    case Q                   = 81
    case R                   = 82
    case S                   = 83
    case T                   = 84
    case U                   = 85
    case V                   = 86
    case W                   = 87
    case X                   = 88
    case Y                   = 89
    case Z                   = 90
    
    case leftBracket         = 91   /* [ */
    case backslash           = 92   /* \ */
    case bightBracket        = 93   /* ] */
    case graveAccent         = 96   /* ` */

//    case a                   = 97
//    case b                   = 98
//    case c                   = 99
//    case d                   = 100
//    case e                   = 101
//    case f                   = 102
//    case g                   = 103
//    case h                   = 104
//    case i                   = 105
//    case j                   = 106
//    case k                   = 107
//    case l                   = 108
//    case m                   = 109
//    case n                   = 110
//    case o                   = 111
//    case p                   = 112
//    case q                   = 113
//    case r                   = 114
//    case s                   = 115
//    case t                   = 116
//    case u                   = 117
//    case v                   = 118
//    case w                   = 119
//    case x                   = 120
//    case y                   = 121
//    case z                   = 122
    
    case world1              = 161  /* non-US #1 */
    case world2              = 162  /* non-US #2 */
    
    /* Function keys */
    case escape              = 256
    case enter               = 257
    case tab                 = 258
    case backspace           = 259
    case insert              = 260
    case delete              = 261
    case right               = 262
    case left                = 263
    case down                = 264
    case up                  = 265
    case pageUp              = 266
    case pageDown            = 267
    case home                = 268
    case end                 = 269
    case capsLock            = 280
    case scrollLock          = 281
    case numLock             = 282
    case printScreen         = 283
    case Pause               = 284
    case f1                  = 290
    case f2                  = 291
    case f3                  = 292
    case f4                  = 293
    case f5                  = 294
    case f6                  = 295
    case f7                  = 296
    case f8                  = 297
    case f9                  = 298
    case f10                 = 299
    case f11                 = 300
    case f12                 = 301
    case f13                 = 302
    case f14                 = 303
    case f15                 = 304
    case f16                 = 305
    case f17                 = 306
    case f18                 = 307
    case f19                 = 308
    case f20                 = 309
    case f21                 = 310
    case f22                 = 311
    case f23                 = 312
    case f24                 = 313
    case f25                 = 314
    
    /* Keypad */
    case kp0                 = 320
    case kp1                 = 321
    case kp2                 = 322
    case kp3                 = 323
    case kp4                 = 324
    case kp5                 = 325
    case kp6                 = 326
    case kp7                 = 327
    case kp8                 = 328
    case kp9                 = 329
    case kpDecimal           = 330
    case kpDivide            = 331
    case kpMultiply          = 332
    case kpSubtract          = 333
    case kpAdd               = 334
    case kpEnter             = 335
    case kpEqual             = 336
    
    /* Modifiers */
    case leftShift           = 340
    case leftControl         = 341
    case leftAlt             = 342
    case leftSuper           = 343
    case rightShift          = 344
    case rightControl        = 345
    case rightAlt            = 346
    case rightSuper          = 347
    case menu                = 348
}
