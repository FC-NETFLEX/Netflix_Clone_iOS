//
//  HomeModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

struct HomeModel: Decodable {
    
    let previewContents: [PreviewModel]
    
    private enum CodingKeys: String, CodingKey {
        case previewContents = "preview_contents"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        previewContents = try container.decode([PreviewModel].self, forKey: .previewContents)
    }
}


