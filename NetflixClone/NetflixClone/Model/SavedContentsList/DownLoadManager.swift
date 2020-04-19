//
//  DownLoadingFile.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/14.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol DownLoadManagerDelegate: class {
    func finishedTask()
}

class DownLoadManager: UIResponder {
    
    weak var delegate: DownLoadManagerDelegate?
    
    private let content: SaveContent
    
    var task: URLSessionDownloadTask?
    
    init(content: SaveContent) {
        self.content = content
        super.init()
    }
    
    // 다운로드 
    func downLoadMovieTask(url: URL) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        let task = session.downloadTask(with: url)
        self.task = task
        
    }
    
    class func downLoadImage(url: URL, completionHandler:@escaping (Result<URL, Error>) -> Void) {
        
        
        let task = URLSession.shared.downloadTask(with: url) {
            (url, response, error) in
            
            guard let url = url else {
                completionHandler(.failure(APIError.noData))
                return
            }
            completionHandler(.success(url))
            
        }
        task.resume()
        
    }
    
    private func completeDownLoad(location: URL) {
//        let manager = SaveFileManager(saveType: .image)
//        guard let saveURL = manager.moveFile(tempURL: location, fileName: String(videoID)) else { return }
//        guard let profile = HaveSaveContentsProfile.default() else { return }
        delegate?.finishedTask()
        let downLoadStatus = DownLoadStatus(contentID: content.contentID, status: .saved)
        postNotification(downLoadStatus: downLoadStatus)
//        content.save
    }
    
    // 비디오 id를 통해서 같은 id를 옵저버 하고있는 뷰들의 업데이트를 위한 노티피케이션 전송
    private func postNotification(downLoadStatus: DownLoadStatus) {
        let notificationName = String(content.contentID)
        let userInfo = [notificationName: downLoadStatus]
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: self, userInfo: userInfo)
    }
    
}

extension DownLoadManager: URLSessionDownloadDelegate {
    // 다운로드 완료
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegate?.finishedTask()
        let downLoadStatus = DownLoadStatus(contentID: content.contentID, status: .saved)
        content.saveVideo(location: location)
        postNotification(downLoadStatus: downLoadStatus)
    }
    
    // 다운로드가 진행됨에 따라 노티피케이션 보냄
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //        print("didWriteData:", bytesWritten) // 이번에 들어온 바이트
        //        print("totalBytesWritten:", totalBytesWritten) // 지금까지 들어온 바이트
        //        print("totalBytesExpectedToWrite:", totalBytesExpectedToWrite) // 총 예상
        
        let current = CGFloat(totalBytesWritten)
        let total = CGFloat(totalBytesExpectedToWrite)
        let percent = current / total
        let downLoadStatus = DownLoadStatus(contentID: content.contentID, status: .downLoading, percent: percent)
        content.status = .downLoading
        content.capacity = totalBytesExpectedToWrite
        postNotification(downLoadStatus: downLoadStatus)
//        print(#function, percent)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(#function)
    }
}


struct DownLoadStatus {
    let contentID: Int
    let status: SaveContentStatus
    let percent: CGFloat
    
    init(contentID: Int, status: SaveContentStatus, percent: CGFloat = 0) {
        self.contentID = contentID
        self.status = status
        self.percent = percent
    }
}
