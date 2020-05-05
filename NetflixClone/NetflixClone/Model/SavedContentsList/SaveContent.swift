//
//  SaveContent.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol SaveContentDelegaet: class {
    
}

enum SaveContentStatus: String, Codable {
    case waiting
    case downLoading
    case saved
    case doseNotSave
    
    func getSign() -> String {
        switch self {
        case .downLoading:
            return "저장 중"
        case .waiting:
            return "저장 대기 중"
        case .saved:
            return "저장 완료"
        case .doseNotSave:
            return "저장"
        }
    }
}

class SaveContent: Decodable {
    
    var superProfile: HaveSaveContentsProfile? {
        get {
            return SavedContentsListModel.shared.getProfile(contentID: self.contentID)
        }
    }
    
    var description: String {
        get {
            var description = self.rating
            if let capacity = self.capacity, let capacityString = switchMBForKB(capacity: capacity) {
                description += " | " + String(capacityString) + "MB"
            }
            return description
        }
    }
    
    var indexPath: IndexPath? {
        for (section, profile) in SavedContentsListModel.shared.profiles.enumerated() {
            for (row, content) in profile.savedContents.enumerated() {
                if content.contentID == self.contentID {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        return nil
    }
    
    let contentID: Int
    
    var savePoint: Int64? // 영상 재생 포인트
    var contentRange: Int64? // 영상 길이
    
    var capacity: Int64? // 용량
    var writtenByte: Int64? // 받은 용량
    
    let title: String // 제목
    let rating: String // 시청 연령
    let summary: String // 줄거리
    private var _imageURL: URL // 이미지
    private var _videoURL: URL // 영상
    let savedDate: Date // 저장 시점
    var isSelected: Bool = false
    var isEditing: Bool = false
    
    
    var status: SaveContentStatus {
        didSet {
            if self.status == .doseNotSave {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    [weak self] in
                    self?.postNotification()
                })
            } else {
                self.postNotification()
            }
        }
    }
    
    
    var imageURL: URL {
        get {
            if let savedImageURL = SaveFileManager(saveType: .movieImage).readFile(contentID: contentID) {
                return savedImageURL
            } else {
                return _imageURL
            }
        }
    }
    
    var videoURL: URL {
        get {
            if let savedVideoURL = SaveFileManager(saveType: .movie).readFile(contentID: contentID) {
                return savedVideoURL
            } else {
                return _videoURL
            }
        }
    }
    
    
    
    init(contentID: Int, title: String, rating: String, summary: String, imageURL: URL, videoURL: URL, status: SaveContentStatus) {
        self.contentID = contentID
        self.title = title
        self.rating = rating
        self.summary = summary
        self._imageURL = imageURL
        self._videoURL = videoURL
        self.savedDate = Date()
        self.status = status
    }
    
    // 영화 다운로드가 끝나면 해당 폴더로 파일을 이동
    func saveVideo(location: URL) {
//        print(#function, location)
        let fileManager = SaveFileManager.init(saveType: .movie)
        
        let url = fileManager.moveFile(tempURL: location, fileName: String(contentID))
        guard let _ = url else { return }
//        print("SaveMovie Success")
//        self.videoURL = videoURL
        saveContentImage()
    }
    
    // 영화 파일이동에 성공하면 영화의 이미지 다운로드 후 다운로드가 완료되면 프로필 정보 업데이트
    private func saveContentImage() {
        DownLoadManager.downLoadImage(url: _imageURL, completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                SaveFileManager(saveType: .movie).deleteFile(url: self._videoURL)
            case .success(let url):
                guard let _ = SaveFileManager(saveType: .movieImage).moveFile(tempURL: url, fileName: String(self.contentID)) else { return }
//                self.imageURL = imageURL
                self.status = .saved
                self.superProfile?.updateProfile()
            }
        })
    }
    
    func cancelDownLoadContent() {
        DownLoading.shared.cancleDownLoad(id: contentID, completion: deleteContent)
    }
    
    func deleteContent() {
//        guard let indexPath = indexPath else { return }
        guard let index = superProfile?.savedContents.firstIndex(where: { $0.contentID == contentID }) else { return }
        SaveFileManager(saveType: .movie).deleteFile(url: self.videoURL)
        SaveFileManager(saveType: .movieImage).deleteFile(url: self.imageURL)
        superProfile?.deleteContent(indexPath: indexPath, index: index)
        status = .doseNotSave
    }
    
    private func postNotification() {
        var percent: CGFloat = 0
        if let current = writtenByte, let total = capacity {
            percent = CGFloat(current) / CGFloat(total)
        }
        let downLoadStatus = DownLoadStatus(contentID: contentID, status: status, percent: percent)
        let notificationName = String(contentID)
        let userInfo = ["status": downLoadStatus]
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: userInfo)
    }
    
    private func switchMBForKB(capacity: Int64) -> String? {
        let multiflire: Double = 1048576
        let result = Double(capacity) / multiflire
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        let resultString = formatter.string(from: result as NSNumber)
        return resultString
    }
    
    
    //MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
        case contentID
        case savePoint
        case contentRange
        case capacity
        case writtenByte
        case title
        case rating
        case summary
        case _imageURL
        case _videoURL
        case savedDate
        case status
        case isSelected
        case isEditing
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentID = try container.decode(Int.self, forKey: .contentID)
        self.savePoint = try container.decode(Int64?.self, forKey: .savePoint)
        self.contentRange = try container.decode(Int64?.self, forKey: .contentRange)
        self.capacity = try container.decode(Int64?.self, forKey: .capacity)
        self.writtenByte = try container.decode(Int64?.self, forKey: .writtenByte)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.summary = try container.decode(String.self, forKey: .summary)
        self._imageURL = try container.decode(URL.self, forKey: ._imageURL)
        self._videoURL = try container.decode(URL.self, forKey: ._videoURL)
        self.savedDate = try container.decode(Date.self, forKey: .savedDate)
        self.status = try container.decode(SaveContentStatus.self, forKey: .status)
        self.isSelected = false
        self.isEditing = false
    }
    
}

extension SaveContent: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentID, forKey: .contentID)
        try container.encode(savePoint, forKey: .savePoint)
        try container.encode(contentRange, forKey: .contentRange)
        try container.encode(capacity, forKey: .capacity)
        try container.encode(writtenByte, forKey: .writtenByte)
        try container.encode(title, forKey: .title)
        try container.encode(rating, forKey: .rating)
        try container.encode(summary, forKey: .summary)
        try container.encode(_imageURL, forKey: ._imageURL)
        try container.encode(_videoURL, forKey: ._videoURL)
        try container.encode(savedDate, forKey: .savedDate)
        try container.encode(status, forKey: .status)
        try container.encode(false, forKey: .isSelected)
        try container.encode(false, forKey: .isEditing)
    }
}


