//
//  SaveContent.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

class SaveContent: Codable {
    
    weak var superProfile: HaveSaveContentsProfile?
    
    let contentID: Int
    
    var savePoint: Int64? // 영상 재생 포인트
    var contentRange: Int64? // 영상 길이
    var capacity: Int64? // 용량
    
    let title: String // 제목
    let rating: String // 시청 연령
    let summary: String // 줄거리
    var imageURL: URL // 이미지
    var videoURL: URL // 영상
    let savedDate: Date // 저장 시점
    
    var status: SaveContentStatus
    var isSelected: Bool = false
    
    init(contentID: Int, title: String, rating: String, summary: String, imageURL: URL, videoURL: URL, status: SaveContentStatus) {
        self.contentID = contentID
        self.title = title
        self.rating = rating
        self.summary = summary
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.savedDate = Date()
        self.status = status
    }
    
    // 영화 다운로드가 끝나면 해당 폴더로 파일을 이동
    func saveVideo(location: URL) {
        print(#function, location)
        let fileManager = SaveFileManager.init(saveType: .movie)
        
        let url = fileManager.moveFile(tempURL: location, fileName: String(contentID))
        guard let videoURL = url else { return }
        print("SaveMovie Success")
        self.videoURL = videoURL
        saveContentImage()
    }
    
    // 영화 파일이동에 성공하면 영화의 이미지 다운로드 후 다운로드가 완료되면 프로필 정보 업데이트
    private func saveContentImage() {
        DownLoadManager.downLoadImage(url: imageURL, completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                SaveFileManager(saveType: .movie).deleteFile(url: self.videoURL)
            case .success(let url):
                guard let imageURL = SaveFileManager(saveType: .movieImage).moveFile(tempURL: url, fileName: String(self.contentID)) else { return }
                self.imageURL = imageURL
                self.status = .saved
                self.superProfile?.updateProfile()
            }
        })
    }
}
