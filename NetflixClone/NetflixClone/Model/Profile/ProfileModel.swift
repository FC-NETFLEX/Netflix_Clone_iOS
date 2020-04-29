//
//  ProfileModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


//프로필 아이콘
struct CategoryList {
    let name: String
    let icon: [Icon]
}
struct Icon {
    let id: Int
    let iconURL: String
}

//프로필 생성

struct ProfileList {
    let id: Int
    let name: String
    let iskids: Bool
}
struct ProfileIcons {
    let idNum: Int
    let iconURL: String
}

