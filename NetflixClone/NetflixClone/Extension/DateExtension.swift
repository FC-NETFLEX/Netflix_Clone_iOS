//
//  DateExtension.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/26.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

extension Date {
    func replaceDateWithString( format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: self)
        return result
    }
}
