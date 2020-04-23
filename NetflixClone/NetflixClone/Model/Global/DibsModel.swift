//
//  DibsModel.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/22.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

//MARK: DibsView Model
struct DibsContent: Codable {
    let id: Int
    let title: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case imageURL = "contents_image"
    }
}
