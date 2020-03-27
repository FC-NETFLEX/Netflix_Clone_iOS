//
//  UIAlertControllerExtension.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func noticePresent(viewController: UIViewController, completion: (() -> Void)? = nil) {
        let action = UIAlertAction(title: "확인", style: .default, handler: {
            _ in
            completion?()
        })
        self.addAction(action)
        viewController.present(self, animated: true)
    }
    
    func defaultPresent(viewController: UIViewController, completion: (() -> Void)? = nil) {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        })
        self.addAction(okAction)
        self.addAction(cancelAction)
        viewController.present(self, animated: true)
    }
    
    func customPresent(viewController: UIViewController, actions: [UIAlertAction]) {
        actions.forEach({
            self.addAction($0)
        })
        viewController.present(self, animated: true)
    }
    
}

