//
//  DownLoading.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

class DownLoading {
    static let shared = DownLoading()
    
    var downLoadingList: [DownLoadManager] = []
    
    func appendDownLoadManager(downLoadManager: DownLoadManager) {
        downLoadManager.delegate = self
        
        if downLoadingList.isEmpty {
            downLoadManager.task?.resume()
        }
        downLoadingList.append(downLoadManager)
    }
}

extension DownLoading: DownLoadManagerDelegate {
    func finishedTask() {
        downLoadingList.remove(at: 0)
        guard !downLoadingList.isEmpty else { return }
        downLoadingList[0].task?.resume()
    }
}
