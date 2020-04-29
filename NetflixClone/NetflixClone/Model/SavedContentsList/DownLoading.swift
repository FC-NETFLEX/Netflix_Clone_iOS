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
    
    var downLoadingList: [DownLoadManager] = [] {
        didSet {
            print(downLoadingList)
            guard let downLoadManager = downLoadingList.first else { return }
            guard downLoadManager.task?.state.rawValue != 0 else { return }
            downLoadManager.task?.resume()
        }
    }
    
    func appendDownLoadManager(downLoadManager: DownLoadManager) {
        downLoadManager.delegate = self
        downLoadingList.append(downLoadManager)
    }
    
    func cancleDownLoad(id: Int, completion: () -> Void) {
        guard let index = downLoadingList.firstIndex(where: { $0.content.contentID == id }) else { return }
        let downLoadManager = downLoadingList[index]
        downLoadManager.task?.cancel()
        downLoadingList.remove(at: index)
        completion()
    }
}

extension DownLoading: DownLoadManagerDelegate {
    func finishedTask() {
        downLoadingList.remove(at: 0)
//        guard !downLoadingList.isEmpty else { return }
//        downLoadingList[0].task?.resume()
    }
    
}
