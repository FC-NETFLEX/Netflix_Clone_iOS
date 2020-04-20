//
//  AppDelegate.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController: UIViewController

        if LoginStatus.shared.checkLoginStatus() {
            rootViewController = UINavigationController(rootViewController: ProfileViewController(root: .main))
        } else {
            rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}

