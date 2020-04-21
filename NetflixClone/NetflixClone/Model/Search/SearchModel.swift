//
//  SearchModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

struct SearchContent: Codable {
    let id: Int
    let title: String
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case image = "contents_image"
    }
}
