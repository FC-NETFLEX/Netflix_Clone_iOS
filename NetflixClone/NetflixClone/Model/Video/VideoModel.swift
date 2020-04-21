//
//  VideoModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


class VideoModel {
    
    let contentID: Int
    let title: String
    var videoID: Int?
    let videoURL: URL
    var range: Int64
    var currentTime: Int64
    var images: [Int64: UIImage] = [:]
    var watching: Watching?
    
    init(
        contentID: Int,
        title: String,
        videoURL: URL,
        range: Int64 = 0,
        currentTime: Int64 = 0,
        images: [Int64: UIImage] = [:],
        videoID: Int? = nil,
        watching: Watching? = nil) {
        self.contentID = contentID
        self.title = title
        self.videoURL = videoURL
        self.range = range
        self.currentTime = currentTime
        self.images = images
        self.videoID = videoID
        self.watching = watching
    }
    
    func getRestTime(currentTime: Int64) -> Int64 {
        let rest = range - currentTime
        return rest
    }
    
    class func `default`(contentID: Int, completionHandler: @escaping (Result<VideoModel, Error>) -> Void) {
        if let model = checkSaveContent(contentID: contentID) {
            completionHandler(.success(model))
        } else {
            requestContent(contentID: contentID, completionHandler: completionHandler)
        }
    }
    
    private class func checkSaveContent(contentID: Int) -> VideoModel? {
        guard let savedContent = SavedContentsListModel.shared.getContent(contentID: contentID) else { return nil }
        return VideoModel(contentID: savedContent.contentID, title: savedContent.title, videoURL: savedContent.videoURL, currentTime: savedContent.savePoint ?? 0 )
    }
    
    private class func requestContent(contentID: Int, completionHandler: @escaping (Result<VideoModel, Error>) -> Void) {
        guard
            let profileID = LoginStatus.shared.getProfileID(),
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.defaultURL.makeURL(
                pathItems: [
                    PathItem(name: "profiles", value: String(profileID)),
                    PathItem(name: "contents", value: String(contentID))
            ])
            else {
                completionHandler(.failure(APIError.badURL))
                return
        }
        
        
        APIManager().request(url: url, method: .get, token: token, body: nil, completionHandler: {
            result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                guard
                    let contentModel = try? JSONDecoder().decode(ContentModel.self, from: data),
                    let videoURL = URL.safetyURL(string: contentModel.content.videoURL)
                    else {
                        completionHandler(.failure(APIError.failedDecoding))
                        return
                }
                let content = contentModel.content
                let model = VideoModel(
                    contentID: content.id,
                    title: content.contentsTitle,
                    videoURL: videoURL,
                    currentTime: content.watching?.savePoint ?? 0,
                    videoID: content.videoID,
                    watching: content.watching)
                completionHandler(.success(model))
            }
        })
        
    }
    
}



