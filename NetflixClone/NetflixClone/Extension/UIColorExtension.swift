//
//  UIColorExtension.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

extension UIColor {
    
//    class var background: UIColor { get { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) } }
//    class var netflixRed: UIColor { get { #colorLiteral(red: 0.8980392157, green: 0.2117647059, blue: 0.1921568627, alpha: 1) } }
//    class var netfilxDarkgray: UIColor { get { #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) } }
//    class var netfilxLightgray: UIColor { get { #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1) } }
    
    enum ColorAsset {
        case white, black, backgroundGray, netflixRed, netflixGray, netflixDarkGray, netflixLightGray, positive, negative, downLoad
    }
    
    static func setNetfilxColor(name: ColorAsset) -> UIColor {
        switch name {
        case .white: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .netflixRed: return .red //
        case .netflixLightGray: return #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1) // 144, 144, 144
        case .netflixGray : return #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // 25, 25, 25
        case .netflixDarkGray: return #colorLiteral(red: 0.2148318528, green: 0.2148318528, blue: 0.2148318528, alpha: 1) // 50, 50, 50
        case .backgroundGray: return #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1) // 20, 20, 20
        case .positive: return .white
        case .negative: return .red
        case .downLoad: return #colorLiteral(red: 0.007843137255, green: 0.3960784314, blue: 0.9098039216, alpha: 1) // 2, 101, 232
        }
    }
}
