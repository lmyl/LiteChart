//
//  LiteChartColor.swift
//  
//
//  Created by 刘洋 on 2020/6/4.
//

import Foundation
import UIKit

/// Color Library
public enum LiteChartColor {
    
    case lightPink
    case pink
    /// 赤红
    case crimson
    /// 薰衣草红
    case lavenderBlush
    case paleVioletRed
    case hotPink
    case deepPink
    case mediumVioletRed
    case orchid
    case thistle
    case plum
    case violet
    case magenta
    case fuchsia
    
    case darkMagenta
    case purple
    case mediumOrchid
    case darkViolet
    case darkOrchid
    case indigo
    case blueViolet
    case mediumPurple
    case mediumSlateBlue
    case slateBlue
    case darkSlateBlue
    case lavender
    case ghostWhite
    case blue
    case mediumBlue
    case midnightBlue
    
    case darkBlue
    case navy
    case royalBlue
    case cornflowerBlue
    case lightSteelBlue
    case lightSlateGray
    case slateGray
    case doderBlue
    case aliceBlue
    case steelBlue
    case lightSkyBlue
    case skyBlue
    case deepSkyBlue
    case lightBlue
    case powderBlue
    case cadetBlue
    
    case azure
    case lightCyan
    case paleTurquoise
    case cyan
    case aqua
    case darkTurquoisa
    case darkSlateGray
    case darkCyan
    case teal
    case mediumTurquoise
    case lightSeaGreen
    case turquoise
    case auqamarin
    case mediumAquamarine
    case mediumSpringGreen
    case mintCream
    
    case springGreen
    case seaGreen
    case honeyDew
    case lightGreen
    case paleGreen
    case darkSeaGreen
    case limeGreen
    case lime
    case forestGreen
    case green
    case darkGreen
    case chartreuse
    case lawnGreen
    case greenYellow
    case oliveDrab
    case beige
    case lightGoldenrodYellow
    
    case ivory
    case lightYellow
    case yellow
    case olive
    case darkKhaki
    case lemonChiffon
    case paleGodenrod
    case khaki
    case gold
    case cornislk
    case goldEnrod
    case floralWhite
    case oldLace
    case wheat
    case moccasin
    case orange
    case papayaWhip
    
    case blanchedAlmond
    case navajoWhite
    case antiqueWhite
    case tan
    case brulyWood
    case bisque
    case darkOrange
    case linen
    case peru
    case peachPuff
    case sandyBrown
    case chocolate
    case saddleBrown
    case seaShell
    case sienna
    case lightSalmon
    
    case coral
    case orangeRed
    case darkSalmon
    case tomato
    case mistyRose
    case salmon
    case snow
    case lightCoral
    case rosyBrown
    case indianRed
    case red
    case brown
    case fireBrick
    case darkRed
    case maroon
    case white
    case whiteSmoke
    
    case gainsboro
    case lightGray
    case silver
    case darkGray
    case Gray
    case dimGray
    case black
    
    case customColor(color: UIColor)
}


extension LiteChartColor {
    /// Get the actual color value
    internal var color: UIColor {
        switch self {
        case .lightPink:
            return UIColor(sRGB3PRed: 255, green: 182, blue: 193)
        case .pink:
            return UIColor(sRGB3PRed: 255, green: 192, blue: 203)
        case .crimson:
            return UIColor(sRGB3PRed: 220, green: 20, blue: 60)
        case .lavenderBlush:
            return UIColor(sRGB3PRed: 255, green: 240, blue: 245)
        case .paleVioletRed:
            return UIColor(sRGB3PRed: 219, green: 112, blue: 147)
        case .hotPink:
            return UIColor(sRGB3PRed: 255, green: 105, blue: 180)
        case .deepPink:
            return UIColor(sRGB3PRed: 255, green: 20, blue: 147)
        case .mediumVioletRed:
            return UIColor(sRGB3PRed: 199, green: 21, blue: 133)
        case .orchid:
            return UIColor(sRGB3PRed: 218, green: 112, blue: 214)
        case .thistle:
            return UIColor(sRGB3PRed: 216, green: 191, blue: 216)
        case .plum:
            return UIColor(sRGB3PRed: 221, green: 160, blue: 221)
        case .violet:
            return UIColor(sRGB3PRed: 238, green: 130, blue: 238)
        case .magenta:
            return UIColor(sRGB3PRed: 255, green: 0, blue: 255)
        case .fuchsia:
            return UIColor(sRGB3PRed: 255, green: 0, blue: 255)
            
            
        case .darkMagenta:
            return UIColor(sRGB3PRed: 139, green: 0, blue: 139)
        case .purple:
            return UIColor(sRGB3PRed: 128, green: 0, blue: 128)
        case .mediumOrchid:
            return UIColor(sRGB3PRed: 186, green: 85, blue: 211)
        case .darkViolet:
            return UIColor(sRGB3PRed: 148, green: 0, blue: 211)
        case .darkOrchid:
            return UIColor(sRGB3PRed: 153, green: 50, blue: 204)
        case .indigo:
            return UIColor(sRGB3PRed: 75, green: 0, blue: 130)
        case .blueViolet:
            return UIColor(sRGB3PRed: 138, green: 43, blue: 226)
        case .mediumPurple:
            return UIColor(sRGB3PRed: 147, green: 112, blue: 219)
        case .mediumSlateBlue:
            return UIColor(sRGB3PRed: 123, green: 104, blue: 238)
        case .slateBlue:
            return UIColor(sRGB3PRed: 106, green: 90, blue: 205)
        case .darkSlateBlue:
            return UIColor(sRGB3PRed: 72, green: 61, blue: 139)
        case .lavender:
            return UIColor(sRGB3PRed: 230, green: 230, blue: 250)
        case .ghostWhite:
            return UIColor(sRGB3PRed: 248, green: 248, blue: 255)
        case .blue:
            return UIColor(sRGB3PRed: 0, green: 0, blue: 255)
        case .mediumBlue:
            return UIColor(sRGB3PRed: 0, green: 0, blue: 205)
        case .midnightBlue:
            return UIColor(sRGB3PRed: 25, green: 25, blue: 112)
            
            
        case .darkBlue:
            return UIColor(sRGB3PRed: 0, green: 0, blue: 139)
        case .navy:
            return UIColor(sRGB3PRed: 0, green: 0, blue: 128)
        case .royalBlue:
            return UIColor(sRGB3PRed: 65, green: 105, blue: 225)
        case .cornflowerBlue:
            return UIColor(sRGB3PRed: 100, green: 149, blue: 237)
        case .lightSteelBlue:
            return UIColor(sRGB3PRed: 179, green: 196, blue: 222)
        case .lightSlateGray:
            return UIColor(sRGB3PRed: 119, green: 136, blue: 153)
        case .slateGray:
            return UIColor(sRGB3PRed: 112, green: 128, blue: 144)
        case .doderBlue:
            return UIColor(sRGB3PRed: 30, green: 144, blue: 255)
        case .aliceBlue:
            return UIColor(sRGB3PRed: 240, green: 248, blue: 255)
        case .steelBlue:
            return UIColor(sRGB3PRed: 70, green: 130, blue: 180)
        case .lightSkyBlue:
            return UIColor(sRGB3PRed: 135, green: 206, blue: 250)
        case .skyBlue:
            return UIColor(sRGB3PRed: 135, green: 206, blue: 250)
        case .deepSkyBlue:
            return UIColor(sRGB3PRed: 0, green: 191, blue: 255)
        case .lightBlue:
            return UIColor(sRGB3PRed: 173, green: 216, blue: 230)
        case .powderBlue:
            return UIColor(sRGB3PRed: 176, green: 224, blue: 230)
        case .cadetBlue:
            return UIColor(sRGB3PRed: 95, green: 158, blue: 160)
            
        case .azure:
            return UIColor(sRGB3PRed: 240, green: 255, blue: 255)
        case .lightCyan:
            return UIColor(sRGB3PRed: 225, green: 255, blue: 255)
        case .paleTurquoise:
            return UIColor(sRGB3PRed: 175, green: 238, blue: 238)
        case .cyan:
            return UIColor(sRGB3PRed: 0, green: 255, blue: 255)
        case .aqua:
            return UIColor(sRGB3PRed: 0, green: 255, blue: 255)
        case .darkTurquoisa:
            return UIColor(sRGB3PRed: 0, green: 206, blue: 209)
        case .darkSlateGray:
            return UIColor(sRGB3PRed: 47, green: 79, blue: 79)
        case .darkCyan:
            return UIColor(sRGB3PRed: 0, green: 139, blue: 139)
        case .teal:
            return UIColor(sRGB3PRed: 0, green: 128, blue: 128)
        case .mediumTurquoise:
            return UIColor(sRGB3PRed: 72, green: 209, blue: 204)
        case .lightSeaGreen:
            return UIColor(sRGB3PRed: 32, green: 178, blue: 170)
        case .turquoise:
            return UIColor(sRGB3PRed: 64, green: 224, blue: 208)
        case .auqamarin:
            return UIColor(sRGB3PRed: 127, green: 255, blue: 170)
        case .mediumAquamarine:
            return UIColor(sRGB3PRed: 0, green: 250, blue: 154)
        case .mediumSpringGreen:
            return UIColor(sRGB3PRed: 245, green: 255, blue: 250)
        case .mintCream:
            return UIColor(sRGB3PRed: 0, green: 255, blue: 127)
            
        case .springGreen:
            return UIColor(sRGB3PRed: 60, green: 179, blue: 113)
        case .seaGreen:
            return UIColor(sRGB3PRed: 46, green: 139, blue: 87)
        case .honeyDew:
            return UIColor(sRGB3PRed: 240, green: 255, blue: 240)
        case .lightGreen:
            return UIColor(sRGB3PRed: 144, green: 238, blue: 144)
        case .paleGreen:
            return UIColor(sRGB3PRed: 152, green: 251, blue: 152)
        case .darkSeaGreen:
            return UIColor(sRGB3PRed: 143, green: 188, blue: 143)
        case .limeGreen:
            return UIColor(sRGB3PRed: 50, green: 205, blue: 50)
        case .lime:
            return UIColor(sRGB3PRed: 0, green: 255, blue: 0)
        case .forestGreen:
            return UIColor(sRGB3PRed: 34, green: 139, blue: 34)
        case .green:
            return UIColor(sRGB3PRed: 0, green: 128, blue: 0)
        case .darkGreen:
            return UIColor(sRGB3PRed: 0, green: 100, blue: 0)
        case .chartreuse:
            return UIColor(sRGB3PRed: 127, green: 155, blue: 0)
        case .lawnGreen:
            return UIColor(sRGB3PRed: 124, green: 252, blue: 0)
        case .greenYellow:
            return UIColor(sRGB3PRed: 173, green: 255, blue: 47)
        case .oliveDrab:
            return UIColor(sRGB3PRed: 85, green: 107, blue: 47)
        case .beige:
            return UIColor(sRGB3PRed: 107, green: 142, blue: 35)
        case .lightGoldenrodYellow:
            return UIColor(sRGB3PRed: 250, green: 250, blue: 210)
            
        case .ivory:
            return UIColor(sRGB3PRed: 255, green: 255, blue: 240)
        case .lightYellow:
            return UIColor(sRGB3PRed: 255, green: 255, blue: 224)
        case .yellow:
            return UIColor(sRGB3PRed: 255, green: 255, blue: 0)
        case .olive:
            return UIColor(sRGB3PRed: 128, green: 128, blue: 0)
        case .darkKhaki:
            return UIColor(sRGB3PRed: 189, green: 183, blue: 107)
        case .lemonChiffon:
            return UIColor(sRGB3PRed: 255, green: 250, blue: 205)
        case .paleGodenrod:
            return UIColor(sRGB3PRed: 238, green: 232, blue: 170)
        case .khaki:
            return UIColor(sRGB3PRed: 240, green: 230, blue: 140)
        case .gold:
            return UIColor(sRGB3PRed: 255, green: 215, blue: 0)
        case .cornislk:
            return UIColor(sRGB3PRed: 255, green: 248, blue: 220)
        case .goldEnrod:
            return UIColor(sRGB3PRed: 218, green: 165, blue: 32)
        case .floralWhite:
            return UIColor(sRGB3PRed: 255, green: 250, blue: 240)
        case .oldLace:
            return UIColor(sRGB3PRed: 253, green: 245, blue: 230)
        case .wheat:
            return UIColor(sRGB3PRed: 245, green: 222, blue: 179)
        case .moccasin:
            return UIColor(sRGB3PRed: 255, green: 228, blue: 181)
        case .orange:
            return UIColor(sRGB3PRed: 255, green: 165, blue: 0)
        case .papayaWhip:
            return UIColor(sRGB3PRed: 255, green: 239, blue: 213)
            
        case .blanchedAlmond:
            return UIColor(sRGB3PRed: 255, green: 235, blue: 205)
        case .navajoWhite:
            return UIColor(sRGB3PRed: 255, green: 222, blue: 173)
        case .antiqueWhite:
            return UIColor(sRGB3PRed: 250, green: 235, blue: 215)
        case .tan:
            return UIColor(sRGB3PRed: 210, green: 180, blue: 140)
        case .brulyWood:
            return UIColor(sRGB3PRed: 222, green: 184, blue: 135)
        case .bisque:
            return UIColor(sRGB3PRed: 255, green: 228, blue: 196)
        case .darkOrange:
            return UIColor(sRGB3PRed: 250, green: 140, blue: 0)
        case .linen:
            return UIColor(sRGB3PRed: 250, green: 240, blue: 230)
        case .peru:
            return UIColor(sRGB3PRed: 205, green: 133, blue: 63)
        case .peachPuff:
            return UIColor(sRGB3PRed: 255, green: 218, blue: 185)
        case .sandyBrown:
            return UIColor(sRGB3PRed: 244, green: 164, blue: 96)
        case .chocolate:
            return UIColor(sRGB3PRed: 210, green: 105, blue: 30)
        case .saddleBrown:
            return UIColor(sRGB3PRed: 139, green: 69, blue: 19)
        case .seaShell:
            return UIColor(sRGB3PRed: 155, green: 245, blue: 238)
        case .sienna:
            return UIColor(sRGB3PRed: 160, green: 82, blue: 45)
        case .lightSalmon:
            return UIColor(sRGB3PRed: 255, green: 160, blue: 122)
            
        case .coral:
            return UIColor(sRGB3PRed: 255, green: 127, blue: 80)
        case .orangeRed:
            return UIColor(sRGB3PRed: 255, green: 69, blue: 0)
        case .darkSalmon:
            return UIColor(sRGB3PRed: 233, green: 150, blue: 122)
        case .tomato:
            return UIColor(sRGB3PRed: 255, green: 99, blue: 71)
        case .mistyRose:
            return UIColor(sRGB3PRed: 255, green: 228, blue: 225)
        case .salmon:
            return UIColor(sRGB3PRed: 250, green: 128, blue: 114)
        case .snow:
            return UIColor(sRGB3PRed: 255, green: 250, blue: 250)
        case .lightCoral:
            return UIColor(sRGB3PRed: 240, green: 128, blue: 128)
        case .rosyBrown:
            return UIColor(sRGB3PRed: 188, green: 143, blue: 143)
        case .indianRed:
            return UIColor(sRGB3PRed: 205, green: 92, blue: 92)
        case .red:
            return UIColor(sRGB3PRed: 255, green: 0, blue: 0)
        case .brown:
            return UIColor(sRGB3PRed: 165, green: 42, blue: 42)
        case .fireBrick:
            return UIColor(sRGB3PRed: 178, green: 34, blue: 34)
        case .darkRed:
            return UIColor(sRGB3PRed: 139, green: 0, blue: 0)
        case .maroon:
            return UIColor(sRGB3PRed: 128, green: 0, blue: 0)
        case .white:
            return UIColor(sRGB3PRed: 255, green: 255, blue: 255)
        case .whiteSmoke:
            return UIColor(sRGB3PRed: 245, green: 245, blue: 245)
            
        case .gainsboro:
            return UIColor(sRGB3PRed: 220, green: 220, blue: 220)
        case .lightGray:
            return UIColor(sRGB3PRed: 211, green: 211, blue: 211)
        case .silver:
            return UIColor(sRGB3PRed: 192, green: 192, blue: 192)
        case .darkGray:
            return UIColor(sRGB3PRed: 169, green: 169, blue: 169)
        case .Gray:
            return UIColor(sRGB3PRed: 128, green: 128, blue: 128)
        case .dimGray:
            return UIColor(sRGB3PRed: 105, green: 105, blue: 105)
        case .black:
            return UIColor(sRGB3PRed: 0, green: 0, blue: 0)
            
        case .customColor(let color):
            return color
            
        }
    }
}
