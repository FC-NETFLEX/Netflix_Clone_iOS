//
//  AppSetUpViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class AppSetUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setNetfilxColor(name: .black)
        
        setNavigationBar()
    }
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        title = "앱 설정"
        navigationItem.leftBarButtonItem = nil
        
    }
    
}
