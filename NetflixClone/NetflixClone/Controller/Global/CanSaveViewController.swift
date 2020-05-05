//
//  CanSaveViewController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class CanSaveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // 다운로드 시작
    private func startDownLoad(saveContent: SaveContent) {
        guard let profile = HaveSaveContentsProfile.default() else { return }
        saveContent.status = .waiting
        profile.startDownLoad(saveContent: saveContent)
    }
    
    // 다운로드 취소
    private func cancelDownLoad(saveContent: SaveContent, indexPath: IndexPath?) {
        
        let actions = [
            UIAlertAction(title: "저장 취소", style: .destructive, handler: { _ in
                saveContent.cancelDownLoadContent()
            }),
            UIAlertAction(title: "취소", style: .cancel)
        ]
        UIAlertController(
            title: saveContent.title,
            message: saveContent.status.getSign() + " 입니다.",
            preferredStyle: .actionSheet)
            .customPresent(viewController: self, actions: actions)
    }
    
    // 저장 콘텐츠 삭제
    private func deleteContent(saveContent: SaveContent, indexPath: IndexPath?) {
        let actions = [
            UIAlertAction(title: "재생", style: .default, handler: { _ in
                self.presentVideoController(contentID: saveContent.contentID)
            }),
            UIAlertAction(title: "저장한 콘텐츠 삭제", style: .destructive, handler: { _ in
                saveContent.deleteContent()
            }),
            UIAlertAction(title: "취소", style: .cancel, handler: nil)
        ]
        
        UIAlertController(
            title: saveContent.title,
            message: nil,
            preferredStyle: .actionSheet)
            .customPresent(viewController: self, actions: actions)
    }
    
    func saveContentControl(status: SaveContentStatus, saveContetnt: SaveContent, indexPath: IndexPath? = nil) {
        switch status {
        case .doseNotSave:
            startDownLoad(saveContent: saveContetnt)
        case .downLoading, .waiting:
            cancelDownLoad(saveContent: saveContetnt, indexPath: indexPath)
        case .saved:
            deleteContent(saveContent: saveContetnt, indexPath: indexPath)
        }
    }
    
    
    
    
}

