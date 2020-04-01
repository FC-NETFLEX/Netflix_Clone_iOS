//
//  VideoModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


struct VideoModel {
    let title: String
    var range: Int64 = 0
    var currentTime: Int64
    var images: [Int64: UIImage] = [:]
    
    func getRestTime(currentTime: Int64) -> Int64 {
        let rest = range - currentTime
        return rest
    }
    
    
    
}



