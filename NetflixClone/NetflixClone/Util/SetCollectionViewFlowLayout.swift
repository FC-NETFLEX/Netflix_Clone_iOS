//
//  SetCollectionViewFlowLayout.swift
//  NetflixClone
//
//  Created by MyMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//
//private enum UI {
//    static let itemsInLine: CGFloat = 3
//    static let linesOnScreen: CGFloat = 3.5
//    static let itemSpacing: CGFloat = CGFloat.dynamicXMargin(margin: 10)
//    static let lineSpacing: CGFloat = CGFloat.dynamicYMargin(margin: 10)
//    static let edgeInsets = UIEdgeInsets(top: CGFloat.dynamicYMargin(margin: 10), left: CGFloat.dynamicXMargin(margin: 10), bottom: CGFloat.dynamicYMargin(margin: 10), right: CGFloat.dynamicXMargin(margin: 10))
//}

import Foundation
import UIKit

struct FlowLayout {
    var itemsInLine: CGFloat
    var linesOnScreen: CGFloat
    let itemSpacing: CGFloat = CGFloat.dynamicXMargin(margin: 10)
    let lineSpacing: CGFloat = CGFloat.dynamicYMargin(margin: 10)
    let edgeInsets = UIEdgeInsets(
        top: CGFloat.dynamicYMargin(margin: 10),
        left: CGFloat.dynamicXMargin(margin: 10),
        bottom: CGFloat.dynamicYMargin(margin: 10),
        right: CGFloat.dynamicXMargin(margin: 10)
    )
    
    init(itemsInLine: CGFloat = 1, linesOnScreen: CGFloat = 1) {
        self.itemsInLine = itemsInLine
        self.linesOnScreen = linesOnScreen
    }
}
