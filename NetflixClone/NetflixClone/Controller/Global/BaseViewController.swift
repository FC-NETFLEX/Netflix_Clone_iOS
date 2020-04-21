//
//  BaseViewController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func presentVideoController(contentID: Int) {
        view.transform = .init(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.view.transform = .init(rotationAngle: .pi / 2)
            self?.view.alpha = 0.1
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            let videoController = VideoController(id: contentID)
            videoController.modalPresentationStyle = .fullScreen
            
            self?.present(videoController, animated: false, completion: {
                self?.view.transform = .identity
                self?.view.alpha = 1
            })
            
        })
    }
    

}
