//
//  ContentModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

struct Contents: Decodable {
    let contents: [Content]
    
    struct Content: Decodable {
        let id: Int
        let contentsTitle: String
        let contentsTitleEnglish: String
        let contentsSummay: String
        let contentsImage: String
        let contentsLogo: String
        let contentsRating: String
        let contentsLength: String
        let contentsPublishingYear: String
        let previewVideo: String
        let actors: [String]
        let directors: [String]
        let isSelected: Bool
        let isLike: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id
            case contentsTitle = "contents_title"
            case contentsTitleEnglish = "contents_title_english"
            case contentsSummay = "contents_summary"
            case contentsImage = "contents_image"
            case contentsLogo = "contents_logo"
            case contentsRating = "contents_rating"
            case contentsLength = "contents_length"
            case contentsPublishingYear = "contents_pub_year"
            case previewVideo = "preview_video"
            case actors
            case diretors
            case isSelected = "is_selected"
            case isLike = "is_like"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            contentsTitle = try container.decode(String.self, forKey: .contentsTitle)
            contentsTitleEnglish = try container.decode(String.self, forKey: .contentsTitleEnglish)
            contentsSummay = try container.decode(String.self, forKey: .contentsSummay)
            contentsImage = try container.decode(String.self, forKey: .contentsImage)
            contentsLogo = try container.decode(String.self, forKey: .contentsLogo)
            contentsRating = try container.decode(String.self, forKey: .contentsRating)
            contentsLength = try container.decode(String.self, forKey: .contentsLength)
            contentsPublishingYear = try container.decode(String.self, forKey: .contentsPublishingYear)
            previewVideo = try container.decode(String.self, forKey: .previewVideo)
            actors = try container.decode([String].self, forKey: .actors)
            directors = try container.decode([String].self, forKey: .diretors)
            isSelected = try container.decode(Bool.self, forKey: .isSelected)
            isLike = try container.decode(Bool.self, forKey: .isLike)
        }
    }
    
}
