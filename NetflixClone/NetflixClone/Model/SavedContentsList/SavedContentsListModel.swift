//
//  SavedContentList.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

enum SaveContentStatus: String, Codable {
    
    case waiting
    case downLoading
    case saved
    
}

struct SavedContentsListModel {
    var saveContens: [SavedContent] = [
        SavedContent(savePoint: 13, contentRange: 1000, title: "미스터 주", rating: "15세", capacity: 100.23, summary: "asd\nd\nd\nd\nd\nd", imageURL: "asd\nd\nd\nd\nd\nd"),
        SavedContent(savePoint: 13, contentRange: 1000, title: "미스터 주", rating: "15세", capacity: 100.23, summary: "asd\nd\nd\nd\nd\nd", imageURL: "asd\nd\nd\nd\nd\nd"),
        SavedContent(savePoint: 13, contentRange: 1000, title: "미스터 주", rating: "15세", capacity: 100.23, summary: "asd\nd\nd\nd\nd\nd", imageURL: "asd\nd\nd\nd\nd\nd"),
        SavedContent(savePoint: 13, contentRange: 1000, title: "미스터 주", rating: "15세", capacity: 100.23, summary: "asd\nd\nd\nd\nd\nd", imageURL: "asd\nd\nd\nd\nd\nd"),
    ]
    
}



struct HaveSaveContentsProfile: Codable {
    var pfofileName: String
    var profileImageURL: String
    var savedConetnts: [SavedContent] = []
}


struct SavedContent: Codable {
    var savePoint: Int64? // 영상 재생 포인트
    var contentRange: Int64? // 영상 길이
    let title: String // 제목
    let rating: String // 시청 연령
    let capacity: Double // 용량
    let summary: String // 줄거리
    let imageURL: String // 이미지
    let videoURL: String = "" // 영상
    var isSelected: Bool = false
}

