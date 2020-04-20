//
//  VideoModel.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


struct VideoModel {
    
    let title: String
    let videoURL: URL
    var range: Int64 = 0
    var currentTime: Int64 = 0
    var images: [Int64: UIImage] = [:]
    
    func getRestTime(currentTime: Int64) -> Int64 {
        let rest = range - currentTime
        return rest
    }
    
    static func `default`(contentID: Int, completionHandler: @escaping (Result<VideoModel, Error>) -> Void) {
        if let model = checkSaveContent(contentID: contentID) {
            completionHandler(.success(model))
        } else {
            requestContent(contentID: contentID, completionHandler: completionHandler)
        }
    }
    
    private static func checkSaveContent(contentID: Int) -> VideoModel? {
        guard let savedContent = SavedContentsListModel.shared.getContent(contentID: contentID) else { return nil }
        return VideoModel(title: savedContent.title, videoURL: savedContent.videoURL, currentTime: savedContent.savePoint ?? 0 )
    }
    
    private static func requestContent(contentID: Int, completionHandler: @escaping (Result<VideoModel, Error>) -> Void) {
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
                let model = VideoModel(title: contentModel.content.contentsTitle, videoURL: videoURL)
                completionHandler(.success(model))
            }
        })
        
    }
    
}



