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

class DownLoadManager: NSObject {
    
    weak var delegate: DownLoadManagerDelegate?
    
    let content: SaveContent
    
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
    
    
}

extension DownLoadManager: URLSessionDownloadDelegate {
    // 다운로드 완료
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        content.saveVideo(location: location)
        delegate?.finishedTask()
        print("===============================\(#function)====================================")
    }
    
    // 다운로드가 진행됨에 따라 노티피케이션 보냄
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //        print("didWriteData:", bytesWritten) // 이번에 들어온 바이트
        //        print("totalBytesWritten:", totalBytesWritten) // 지금까지 들어온 바이트
        //        print("totalBytesExpectedToWrite:", totalBytesExpectedToWrite) // 총 예상
        
        content.capacity = totalBytesExpectedToWrite
        content.writtenByte = totalBytesWritten
        content.status = .downLoading
//        print(content.status)
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
