//
//  DownLoadingFile.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/14.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


class DownLoadManager: UIResponder {
    
    private let id: Int
    private var task: URLSessionDownloadTask?
    
    init(id: Int) {
        self.id = id
    }
    
    func downLoadTask(url: URL, delegate: URLSessionDownloadDelegate) {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        self.task = task
        
    }
    
    private func postNotification(downLoadStatus: DownLoadStatus) {
        let notificationName = String(id)
        let userInfo = [notificationName: downLoadStatus]
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: self, userInfo: userInfo)
    }
    
}

extension DownLoadManager: URLSessionDownloadDelegate {
    // 다운로드 완료
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishedDownLoadingTo")
        let downLoadStatus = DownLoadStatus(id: id, status: .saved)
        postNotification(downLoadStatus: downLoadStatus)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //        print("didWriteData:", bytesWritten) // 이번에 들어온 바이트
        //        print("totalBytesWritten:", totalBytesWritten) // 지금까지 들어온 바이트
        //        print("totalBytesExpectedToWrite:", totalBytesExpectedToWrite) // 총 예상
        
        let current = CGFloat(totalBytesWritten)
        let total = CGFloat(totalBytesExpectedToWrite)
        let percent = current / total
        let downLoadStatus = DownLoadStatus(id: id, status: .downLoading, percent: percent)
        postNotification(downLoadStatus: downLoadStatus)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(#function)
    }
}


struct DownLoadStatus {
    let id: Int
    let status: SaveContentStatus
    let percent: CGFloat
    
    init(id: Int, status: SaveContentStatus, percent: CGFloat = 0) {
        self.id = id
        self.status = status
        self.percent = percent
    }
}
