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
        return timeCalculater(second: rest)
    }
    
    private func timeCalculater(second: Int64) -> String {
        let hour = second / 3600
        let minute = (second % 3600) / 60
        let second = (second % 3600) % 60
        
        let hourString: String
        let minuteString = minute < 10 ? "0" + String(minute) + ":": String(minute) + ":"
        let secondString = second < 10 ? "0" + String(second): String(second)
        
        switch hour {
        case (let hour) where hour < 1:
            hourString = ""
        case (let hour) where hour < 10:
            hourString = "0" + String(hour) + ":"
        default:
            hourString = String(hour) + ":"
        }
        
        return hourString + minuteString + secondString
    }
}



