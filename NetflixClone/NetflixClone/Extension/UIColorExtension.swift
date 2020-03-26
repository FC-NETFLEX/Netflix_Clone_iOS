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
        case white, black, backgroundGray, netflixRed, netfilxGray, netfilxDarkGray, netfilxLightGray
    }
    
    static func setNetfilxColor(name: ColorAsset) -> UIColor {
        switch name {
        case .white: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .netflixRed: return #colorLiteral(red: 0.8980392157, green: 0.2117647059, blue: 0.1921568627, alpha: 1) //
        case .netfilxLightGray: return #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1) // 95, 95, 95
        case .netfilxGray : return #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // 25, 25, 25
        case .netfilxDarkGray: return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // 50, 50, 50
        case .backgroundGray: return #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1) // 20, 20, 20
        }
    }
}
