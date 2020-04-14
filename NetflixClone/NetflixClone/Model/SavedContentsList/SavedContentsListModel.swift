//
//  SavedContentList.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

enum SaveContentStatus: String, Codable {
    case waiting = "대기중"
    case downLoading = "저장중"
    case saved = "저장 완료"
}

class SavedContentsListModel {
    
    static var shared = SavedContentsListModel()
    
    private let userDefaults = UserDefaults.standard

    var savedContentsList: [Int: HaveSaveContentsProfile] = [:]
    
    init() {
        getSavedContentsList()
    }
    
    deinit {
        putSavedContentsList()
    }
    
    func sortedSavedContensList() {
        guard let profileID = LoginStatus.shared.getProfileID() else { return }
        
    }
    
    func getSavedContentsList() {
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = userDefaults.data(forKey: email),
            let savedContentsList = try? JSONDecoder().decode([Int: HaveSaveContentsProfile].self, from: data)
            else { return }
        self.savedContentsList = savedContentsList
    }
    
    func putSavedContentsList() {
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = try? JSONEncoder().encode(self.savedContentsList)
            else { return }
        userDefaults.set(data, forKey: email)
    }
    
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
    let videoURL: String // 영상
    
    var status: SaveContentStatus
    var isSelected: Bool = false
}

