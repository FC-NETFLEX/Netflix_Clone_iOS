//
//  VideoModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


struct VideoModel {
    var range: Int64 = 0
    var currentTime: Int64 = 0
    
    func getRestRangeWithString() -> String {
        let rest = range - currentTime
        let restDate = Date(timeIntervalSinceReferenceDate: Double(rest))
        return restDate.replaceDateWithString(format: "HH:mm:ss")
    }
}
