//
//  SavedContentList.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
import Kingfisher

enum SaveContentStatus: String, Codable {
    case waiting 
    case downLoading
    case saved
    case doseNotSave
    
    func getSign() -> String {
        switch self {
        case .waiting, .downLoading:
            return "저장중"
        case .saved:
            return "저장 완료"
        case .doseNotSave:
            return "저장"
        }
    }
}

protocol SavedContentsListModelDelegate: class {
    func didchange()
}

class SavedContentsListModel {
    
    weak var delegate: SavedContentsListModelDelegate?
    
    static var shared = SavedContentsListModel()
    
    private let userDefaults = UserDefaults.standard

    var profiles: [HaveSaveContentsProfile] = []

    
    init() {
        getSavedContentsList()
        sortedSavedContensList()
    }
    
    deinit {
        print("SavedContentsListModel deinit")
        
    }
    
    private func sortedSavedContensList() {
        guard let profileID = LoginStatus.shared.getProfileID() else { return }
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else { return }
        profiles.swapAt(index, 0)
    }
    
    private func getSavedContentsList() {
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = userDefaults.data(forKey: email),
            let savedContentsList = try? JSONDecoder().decode([HaveSaveContentsProfile].self, from: data)
            else { return }
        self.profiles = savedContentsList
        profiles.forEach({ (profile) in
            profile.savedContents.forEach({
                $0.superProfile = profile
            })
        })
    }
    
    func putSavedContentsList() {
        profiles.forEach({
            $0.savedContents.forEach({
                $0.superProfile = nil
            })
        })
        guard
            let email = LoginStatus.shared.getEmail(),
            let data = try? JSONEncoder().encode(self.profiles)
            else { return }
        userDefaults.set(data, forKey: email)
        delegate?.didchange()
        
    }
    
    func getContent(indexPath: IndexPath) -> SaveContent {
        profiles[indexPath.section].savedContents[indexPath.row]
    }
    
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
    
        
    
}





