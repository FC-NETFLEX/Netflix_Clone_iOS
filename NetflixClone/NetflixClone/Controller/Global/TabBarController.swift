//
//  TabBarController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addViewControllers()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func addViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem.title = "검색"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let saveContentListVC = SaveContentListViewController()
        saveContentListVC.tabBarItem.title = "저장한 콘텐츠 목록"
        saveContentListVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line.alt")
        
        let moreVC = MoreViewController()
        moreVC.tabBarItem.title = "더보기"
        moreVC.tabBarItem.image = UIImage(systemName: "line.horizontal.3")
        
        setViewControllers([homeVC, searchVC, saveContentListVC, moreVC], animated: true)
    }
    
    private func setUI() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
    }
    
    func changeRootViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = self
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
