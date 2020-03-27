//
//  UIViewControllerExtension.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    //VideonController를 present할때 애니메이션, 객체 세팅까지 완료후 present
    func presentVideoController(urlString: String, title: String, savePoint: Int64 = 0) {
        
        view.transform = .init(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.view.transform = .init(rotationAngle: .pi / 2)
            self?.view.alpha = 0.1
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            
            guard let url = URL(string: urlString) else { return }
            let videoController = VideoController(url: url, title: title, savePoint: savePoint)
            videoController.modalPresentationStyle = .fullScreen
            
            self?.present(videoController, animated: true, completion: {
                self?.view.transform = .identity
                self?.view.alpha = 1
            })
            
        })
    }
}
