//
//  Category.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/06.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


//enum Category: Int {
//    case drama = 1
//    case romance = 5
//    case adventure = 6
//    case thriller = 7
//    case documentary = 10
//    case comedy = 11
//    case family = 12
//    case mystery = 13
//    case war = 14
//    case animation = 15
//    case crime = 16
//    case musical = 17
//    case SF = 18
//    case action = 19
//}

struct Category {
    let keys = [1, 5, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
    let category = [
        1: "드라마",
        5: "로맨스",
        6: "모험",
        7: "스릴러",
        10: "다큐멘터리",
        11: "코미디",
        12: "가족",
        13: "미스터리",
        14: "전쟁",
        15: "애니메이션",
        16: "범죄",
        17: "뮤지컬",
        18: "SF",
        19: "액션",
    ]
}

