//
//  PreviewModel.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

struct PreviewModel: Decodable {
    let id: Int
    let contentsTitle: String
    let previewVideo: String
    let contentsLogo: String?
    
    private enum CodingKeys: String, CodingKey {
        // 백그라운드 이미지 (요청 끝나기전에 보여주는 블러 된 이미지)
        case id
        case contentsTitle = "contents_title"
        case previewVideo = "preview_video"
        case contentsLogo = "contents_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        contentsTitle = try container.decode(String.self, forKey: .contentsTitle)
        previewVideo = try container.decode(String.self, forKey: .previewVideo)
        contentsLogo = try container.decode(String?.self, forKey: .contentsLogo)
        
    }
}


