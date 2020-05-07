//
//  HaveSaveContentsProfile.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
protocol HaveSaveContentsProfileDelegate: class {
    
}

class HaveSaveContentsProfile: Codable {
    
    let id: Int
    var name: String
    private var _imageURL: URL
    var savedContents: [SaveContent] //{
//        didSet {
//            if self.savedContents.isEmpty {
//                removeProfile()
//                SavedContentsListModel.shared.putSavedContentsList()
//            }
//        }
//    }
    
    var imageURL: URL {
        get {
            if let savedImageURL = SaveFileManager(saveType: .profileImage).readFile(contentID: id) {
                return savedImageURL
            } else {
                return _imageURL
            }
        }
    }
    
    
    // SaveContentsListModel에 현재의 프로필이 존재하면 있는거 반환, 없으면 만들어서 반환
    class func `default`() -> HaveSaveContentsProfile? {
        var resultProfile: HaveSaveContentsProfile
        
        if let index = checkExistenceProfile() {
            guard let currentProfile = LoginStatus.shared.getProfile() else { return nil }
            
            let profile = SavedContentsListModel.shared.profiles[index]
            profile._imageURL = currentProfile.imageURL
            profile.name = currentProfile.name
            resultProfile = profile
        } else {
            guard let currentProfile = LoginStatus.shared.getProfile() else { return nil}
            
            let profile = HaveSaveContentsProfile(
                id: currentProfile.id,
                name: currentProfile.name,
                imageURL: currentProfile.imageURL)
            SavedContentsListModel.shared.profiles.insert(profile, at: 0)
            resultProfile = profile
        }
        
        return resultProfile
    }
    
    init(id: Int, name: String, imageURL: URL, savedContents: [SaveContent] = []) {
        self.id = id
        self.name = name
        self._imageURL = imageURL
        self.savedContents = savedContents
    }
    
    // SaveContentsListModel에 현재의 프로필이 존재 하는지 체크하고 있으면 index를 반환
    class private func checkExistenceProfile() -> Int? {
        guard let id = LoginStatus.shared.getProfileID() else { return nil }
        let result = SavedContentsListModel.shared.profiles.firstIndex(where: { $0.id == id })
        return result
    }
    
    // profile update (이미지 파일로 저장하고 URL 저장)후 userdefaults에 저장
    func updateProfile() {
        
        guard let currentProfile = LoginStatus.shared.getProfile() else { return }
        name = currentProfile.name
        
        DownLoadManager.downLoadImage(url: currentProfile.imageURL, completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
                let _ = SaveFileManager(saveType: .profileImage).moveFile(tempURL: url, fileName: String(self.id))
//                self.imageURL = url
                SavedContentsListModel.shared.putSavedContentsList()
            }
        })
    }
    
    func removeProfile() {
        let model = SavedContentsListModel.shared
        guard let index = model.profiles.firstIndex(where: { $0.id == id }) else { return }
        SaveFileManager(saveType: .profileImage).deleteFile(url: imageURL)
        model.profiles.remove(at: index)
        SavedContentsListModel.shared.putSavedContentsList()
    }
    
    // 다운로드 시작
    func startDownLoad(saveContent: SaveContent) {
//        saveContent.superProfile = self
        savedContents.insert(saveContent, at: 0)
        let downLoadManager = DownLoadManager(content: saveContent)
        downLoadManager.downLoadMovieTask(url: saveContent.videoURL)
        DownLoading.shared.appendDownLoadManager(downLoadManager: downLoadManager)
    }
    
    func deleteContent(indexPath: IndexPath?, index: Int) {
        savedContents.remove(at: index)
        SavedContentsListModel.shared.putSavedContentsList(indexPath: indexPath)
        if savedContents.isEmpty, indexPath == nil {
            removeProfile()
        }
    }
    
    
    //MARK: Codable

//    private enum CodingKeys: String, CodingKey {
//        case delegate
//        case id
//        case name
//        case _imageURL
//        case savedContents
//    }
//
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.delegate = nil
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self._imageURL = try container.decode(URL.self, forKey: ._imageURL)
//        self.savedContents = try container.decode([SaveContent].self, forKey: .savedContents)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(_imageURL, forKey: ._imageURL)
//        try container.encode(savedContents, forKey: .savedContents)
////        try container.encode(nil, forKey: .delegate)
//    }
    
    
}


