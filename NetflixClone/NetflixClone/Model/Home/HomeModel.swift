//
//  HomeModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


struct HomeContent: Codable {
    let topContent: TopConent
    let adContent: ADContent
    let top10Contents: [Top10Content]
    let recommendContents: [RecommendContent]
    let previewContents: [PreviewContent]
    let watchingVideo: [WatchVideo]
    
    private enum CodingKeys: String, CodingKey {
        case topContent = "top_contents"
        case adContent = "ad_contents"
        case top10Contents = "top10_contents"
        case recommendContents = "recommend_contents"
        case previewContents = "preview_contents"
        case watchingVideo = "watching_video"
    }
}

struct CategoryContent: Codable {
    let topContent: TopConent
    let similarContent: [RecommendContent]
    
    private enum CodingKeys: String, CodingKey {
        case topContent = "contents"
        case similarContent = "similar_contents"
    }
}



struct TopConent: Codable {
    let id: Int
    let title: String
    let imageURL: String
    let logoImageURL: String
    let categories: [String]
    let rating: String          // 관람가
    var selectedFlag: Bool
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        //        case titleEnglish = "contents_title_english"
        case imageURL = "contents_image"
        case logoImageURL = "contents_logo"
        case rating = "contents_rating"
        case selectedFlag = "is_select"
        case categories
        
        
        //        case likeFlag = "is_like"
        //        case summary = "contents_summary"
        //        case timeLength = "contents_length"
        //        case pubYear = "contents_pub_year"
        //    case previewVideo = "preview_video"
        //    case actors
        //        case directors
        //    case videos
    }
}


struct ADContent: Codable {
    let id: Int
    let title: String
    let titleEnglish: String
    let timeLength: String
    let pubYear: String
    let previewVideoURL: String
    var selected: Bool
    //    let summary: String
    //    let imageString: String
    //    let logoString: String
    //    let rating: String      // 관람가
    //    let actors: [String]
    //    let directors: [String]
    //    let videos: [String]
    //    let likeFlag: Bool
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case titleEnglish = "contents_title_english"
        case timeLength = "contents_length"
        case pubYear = "contents_pub_year"
        case previewVideoURL = "preview_video"
        case selected = "is_select"
    }
}

struct Top10Content: Codable {
    let id: Int
    let title: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case imageURL = "contents_image"
    }
}

struct RecommendContent: Codable {
    let id: Int
    let title: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case imageURL = "contents_image"
        
    }
}



struct PreviewContent: Codable {
    let id: Int
    let title: String
    let previewVideoURL: String
    let logoURL: String
    let poster: String
    let videos: [Video]
    let categories: [String]
    let isSelect: Bool
    var genre: String {
        categories.joined(separator: " ・ ")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "contents_title"
        case previewVideoURL = "preview_video"
        case logoURL = "contents_logo"
        case poster = "contents_image"
        case videos
        case categories
        case isSelect = "is_select"
    }
}


struct WatchVideo: Codable {
    let id: Int?
    let video: Video?
    let playTime: Int
    let videoLength: Int
    let poster: String
    let contentId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case video
        case playTime = "playtime"
        case videoLength = "video_length"
        case poster = "contents_image"
        case contentId = "contents_id"
    }
    
    
}

struct Video: Codable {
    let id: Int
    let videoURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case videoURL = "video_url"
    }
}


