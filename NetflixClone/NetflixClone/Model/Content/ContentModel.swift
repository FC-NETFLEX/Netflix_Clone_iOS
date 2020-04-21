//
//  ContentModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

//struct Contents: Decodable {
//    let contents: [Content]
//

struct ContentModel: Decodable {
    
    let content: ContentDetail
    let similarContents: [SimilarContent]
    
    private enum CodingKeys: String, CodingKey {
        case content = "contents"
        case similarContents = "similar_contents"
    }
}


struct ContentDetail: Decodable {
    let id: Int
    let contentsTitle: String
    let contentsTitleEnglish: String
    let contentsSummay: String
    let contentsImage: String
    let contentsLogo: String?
    let contentsRating: String
    let contentsLength: String
    let contentsPublishingYear: String
    let previewVideo: String?
    let actors: [String]
    let directors: [String]
    let isSelected: Bool
    let isLike: Bool
    let videoURL: String
    let videoID: Int
    let watching: Watching?
    
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
        case directors
        case isSelected = "is_select"
        case isLike = "is_like"
        case video = "videos"
        case watching
    }
    
    private enum NestedKeys: String, CodingKey {
        case videoURL = "video_url"
        case videoID = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        contentsTitle = try container.decode(String.self, forKey: .contentsTitle)
        contentsTitleEnglish = try container.decode(String.self, forKey: .contentsTitleEnglish)
        contentsSummay = try container.decode(String.self, forKey: .contentsSummay)
        contentsImage = try container.decode(String.self, forKey: .contentsImage)
        contentsLogo = try container.decode(String?.self, forKey: .contentsLogo)
        contentsRating = try container.decode(String.self, forKey: .contentsRating)
        contentsLength = try container.decode(String.self, forKey: .contentsLength)
        contentsPublishingYear = try container.decode(String.self, forKey: .contentsPublishingYear)
        previewVideo = try container.decode(String?.self, forKey: .previewVideo)
        actors = try container.decode([String].self, forKey: .actors)
        directors = try container.decode([String].self, forKey: .directors)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        isLike = try container.decode(Bool.self, forKey: .isLike)
        watching = try container.decode(Watching?.self, forKey: .watching)
        var videoArray = try container.nestedUnkeyedContainer(forKey: .video)
        let nestedContaner = try videoArray.nestedContainer(keyedBy: NestedKeys.self)
        
        videoID = try nestedContaner.decode(Int.self, forKey: .videoID)
        videoURL = try nestedContaner.decode(String.self, forKey: .videoURL)
        
    }
}


struct SimilarContent: Decodable {
    
    let id: Int
    let title: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case imageURL = "contents_image"
    }
}

struct Watching: Decodable {
    
    let id: Int
    let videoID: Int
    let savePoint: Int64
    let videoRange: Int64
    
    private enum CodingKeys: String, CodingKey {
        case id
        case videoID = "video"
        case savePoint = "playtime"
        case videoRange = "video_length"
    }
    
}

//}
