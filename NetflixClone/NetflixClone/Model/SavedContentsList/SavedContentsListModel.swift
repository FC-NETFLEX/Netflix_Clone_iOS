//
//  SavedContentList.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
import Kingfisher


protocol SavedContentsListModelDelegate: class {
    func didchange(indexPath: IndexPath?)
    func deleteProfile(section: Int) 
}

class SavedContentsListModel {
    
    weak var delegate: SavedContentsListModelDelegate?
    
    static var shared = SavedContentsListModel()
    
    private let userDefaults = UserDefaults.standard

    var profiles: [HaveSaveContentsProfile] = [] 
    
    var totalConetntCount: Int {
        get {
            var result = 0
            profiles.forEach({
                $0.savedContents.forEach({ _ in
                    result += 1
                })
            })
            return result
        }
    }
    
    init() {
        getSavedContentsList()
        sortedSavedContensList()
    }
    
    deinit {
        print("SavedContentsListModel deinit")
        
    }
    
    // 현재 접속중인 프로필을 최상단으로 정렬
    private func sortedSavedContensList() {
        guard let profileID = LoginStatus.shared.getProfileID() else { return }
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else { return }
        profiles.swapAt(index, 0)
    }
    
    // UserDefaults 에서 꺼내오기
    private func getSavedContentsList() {
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = userDefaults.data(forKey: email),
            let savedContentsList = try? JSONDecoder().decode([HaveSaveContentsProfile].self, from: data)
            else { return }
        self.profiles = savedContentsList
        
//        let needResumContent = profiles.flatMap({ $0.savedContents }).filter({ $0.status == .downLoading || $0.status == .waiting }).reversed()
//        print("needResumContent", needResumContent)
//        
//        needResumContent.forEach({ saveContent in
//            if !DownLoading.shared.downLoadingList.contains(where: { $0.content.contentID == saveContent.contentID }) {
//                saveContent.status = .waiting
//                let downLoadManager = DownLoadManager(content: saveContent)
//                downLoadManager.downLoadMovieTask(url: saveContent.videoURL)
//                DownLoading.shared.appendDownLoadManager(downLoadManager: downLoadManager)
//                print(#function, "*****************************************************")
////                dump(saveContent)
//                print([saveContent])
//                print(#function, "*****************************************************")
//            }
//        })
        
    }
    
    func againResumDownloadTasks() {
        
        let needResumContent = profiles
            .flatMap({ $0.savedContents })
            .filter({ $0.status == .downLoading || $0.status == .waiting })
            .reversed()
        
//        dump(needResumContent)
        
        needResumContent.forEach({ saveContent in
            if !DownLoading.shared.downLoadingList.contains(where: { $0.content.contentID == saveContent.contentID }) {
                saveContent.status = .waiting
                let downLoadManager = DownLoadManager(content: saveContent)
                downLoadManager.downLoadMovieTask(url: saveContent.videoURL)
                DownLoading.shared.appendDownLoadManager(downLoadManager: downLoadManager)
                print(#function, "*****************************************************")
                dump(saveContent)
                print([saveContent])
                print(#function, "*****************************************************")
            }
        })
    }
    
    // UserDefaults 에 저장
    func putSavedContentsList(indexPath: IndexPath? = nil) {
//        profiles.forEach({
//            $0.savedContents.forEach({
//                $0.superProfile = nil
//            })
//        })
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = try? JSONEncoder().encode(self.profiles)
            else { return }
        userDefaults.set(data, forKey: email)
        delegate?.didchange(indexPath: indexPath)
        
    }
    
    // indexPath로 content찾아서 반환
    func getContent(indexPath: IndexPath) -> SaveContent {
        profiles[indexPath.section].savedContents[indexPath.row]
    }
    
    // cotentID로 content찾아서 반환
    func getContent(contentID: Int) -> SaveContent? {
        
        var content: SaveContent?
        profiles.forEach({
            $0.savedContents.forEach({
                if $0.contentID == contentID {
                    content = $0
                }
            })
        })
        
        return content
    }
    
    func getProfile(contentID: Int) -> HaveSaveContentsProfile? {
        
        for profile in profiles {
            if profile.savedContents.contains(where: { $0.contentID == contentID }) {
                return profile
            }
        }
        return nil
    }
        
    
    func getWatchingContentOfSavedContent() -> [WatchVideo] {
        var tempContents: [SaveContent] = []
        profiles.forEach({
            let contents = $0.savedContents.filter({ $0.contentRange != nil && $0.savePoint != nil })
            tempContents += contents
        })
        let result: [WatchVideo] = tempContents.compactMap({ (content: SaveContent) in
            guard
                let range = content.contentRange,
                let savePoint = content.savePoint
                else { return nil }
            let watchingContent = WatchVideo(
                id: nil,
                video: nil,
                playTime: Int(savePoint),
                videoLength: Int(range),
                poster: content.imageURL.absoluteString,
                contentId: content.contentID)
            return watchingContent
        })
        
        return result
    }
    
    // 모든 파일을 지우는 메서드
    func deleteAllFiles() {
        for (section, profile) in profiles.enumerated() {
            for (row, savedContent) in profile.savedContents.enumerated() {
                savedContent.deleteContent()
            }
        }
    }
    // 넷플릭스 저장용랑
    func totalCapacity() -> Double {
        
        let savedContents = profiles.flatMap({
            $0.savedContents
        })
        
        let result = savedContents.reduce(into: 0.0, {
            $0 += Double($1.capacity ?? 0)
        })
        
        return result
    }
    
}





