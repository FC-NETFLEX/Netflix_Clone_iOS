//
//  TabBarController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addViewControllers()
        setUI()
        SavedContentsListModel.shared.setInitialization()
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
        
        let searchVC = UINavigationController(rootViewController: SearchViewController()) 
        searchVC.tabBarItem.title = "검색"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let saveContentListVC = UINavigationController(rootViewController: SavedContentsListViewController())
        saveContentListVC.tabBarItem.title = "저장한 콘텐츠 목록"
        saveContentListVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line.alt")
        
        let moreVC = UINavigationController(rootViewController: MoreViewController())
        moreVC.tabBarItem.title = "더보기"
        moreVC.tabBarItem.image = UIImage(systemName: "line.horizontal.3")
        
        let testVC = TestViewController()
        testVC.tabBarItem.title = "Test"
        
        
        
        setViewControllers([homeVC, searchVC, saveContentListVC, moreVC, testVC], animated: true)
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
