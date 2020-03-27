//
//  VideoModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


struct VideoModel {
    let title: String
    var range: Int64 = 0
    var currentTime: Int64
    
    func getRestRangeWithString() -> String {
        let rest = range - currentTime
        return replaceIntWithTimeString(second: rest)
    }
    
    func getCurrentTimeWithString() -> String {
        replaceIntWithTimeString(second: currentTime)
    }
    
    private func replaceIntWithTimeString(second: Int64) -> String {
        let hour = second / 3600
        let minute = (second % 3600) / 60
        let second = (second % 3600) % 60
        
        let hourString = hour < 1 ? "": String(hour) + ":"
        let minuteString = minute < 10 ? "0" + String(minute) + ":": String(minute) + ":"
        let secondString = second < 10 ? "0" + String(second): String(second)
        
        
        return hourString + minuteString + secondString
    }
}



