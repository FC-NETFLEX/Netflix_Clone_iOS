//
//  MoreViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import AVKit
//enum RootVC {
//    case main
//    case edite
//    case normal
//}

class MoreViewController: UIViewController {
   

    private let tempLogoutbutton = UIButton(type: .system)
    private let tempVideoButton = UIButton(type: .system)
    private let tempAddProfileButton = UIButton(type: .system)
    private let tempProfileManagerButton = UIButton(type: .system)
    private let tempChoiceProfileButton = UIButton(type: .system)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testUI()
        testConstraint()
    }

}


// MARK: Test
extension MoreViewController {
    
    private func testUI() {
        view.addSubview(tempLogoutbutton)
        tempLogoutbutton.setTitle("로그아웃", for: .normal)
        tempLogoutbutton.tintColor = .white
        tempLogoutbutton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        view.addSubview(tempVideoButton)
        tempVideoButton.setTitle("비디오", for: .normal)
        tempVideoButton.tintColor = .white
        tempVideoButton.addTarget(self, action: #selector(didTapVideoButton), for: .touchUpInside)
        
        view.addSubview(tempAddProfileButton)
        tempAddProfileButton.setTitle("프로필추가", for: .normal)
        tempAddProfileButton.tintColor = .white
        tempAddProfileButton.addTarget(self, action: #selector(didTapTempAddProfileButton), for: .touchUpInside)
        
        view.addSubview(tempProfileManagerButton)
        tempProfileManagerButton.setTitle("프로필관리", for: .normal)
        tempProfileManagerButton.tintColor = .white
        tempProfileManagerButton.addTarget(self, action: #selector(didTapTempProfileManagerButton), for: .touchUpInside)
        
        view.addSubview(tempChoiceProfileButton)
        tempChoiceProfileButton.setTitle("첫화면프로필선택", for: .normal)
        tempChoiceProfileButton.tintColor = .white
        tempChoiceProfileButton.addTarget(self, action: #selector(didTapTempChoiceProfileButton), for: .touchUpInside)
        
        
        
    }
    
    private func testConstraint() {
        tempLogoutbutton.frame.size = CGSize(width: 80, height: 40)
        tempLogoutbutton.center.x = view.center.x
        tempLogoutbutton.center.y = view.center.y + 200
        
        tempVideoButton.frame.size = CGSize(width: 80, height: 40)
        tempVideoButton.center.x = view.center.x
        tempVideoButton.center.y = tempLogoutbutton.center.y - 100
        
        tempAddProfileButton.frame.size = CGSize(width: 80, height: 40)
        tempAddProfileButton.center.x = view.center.x
        tempAddProfileButton.center.y = tempVideoButton.center.y - 100
        
        tempProfileManagerButton.frame.size = CGSize(width: 80, height: 40)
        tempProfileManagerButton.center.x = view.center.x
        tempProfileManagerButton.center.y = tempAddProfileButton.center.y - 100
        
        tempChoiceProfileButton.frame.size = CGSize(width: 120, height: 40)
        tempChoiceProfileButton.center.x = view.center.x
        tempChoiceProfileButton.center.y = tempProfileManagerButton.center.y - 100
    }
    
    @objc private func didTapLogoutButton() {
        LoginStatus.shared.logout()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let window = appDelegate.window
        let rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
    }
    
    @objc private func didTapVideoButton() {
        
        let urlString = "ttps://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/videoplayback.mp4"
        presentVideoController(urlString: urlString, title: "Test")
        

    }
    @objc private func didTapTempAddProfileButton() {
        let profileVC = ProfileViewController(root: .add)
        let navi = UINavigationController(rootViewController: profileVC)
        print("추가")
        present(navi, animated: true)
        
        
    }
    @objc private func didTapTempChoiceProfileButton() {
        let profileVC = ProfileViewController(root: .main)
        let navi = UINavigationController(rootViewController: profileVC)
        print("메인")
        present(navi, animated: true)
        
        
    }
    @objc private func didTapTempProfileManagerButton() {
        
        let profileVC = ProfileViewController(root: .manager)
        let navi = UINavigationController(rootViewController: profileVC)
        print("관리")
        present(navi, animated: true)
        
    }
    
}
