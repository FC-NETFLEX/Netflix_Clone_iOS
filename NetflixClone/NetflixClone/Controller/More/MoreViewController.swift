//
//  MoreViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import AVKit

class MoreViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let tempLogoutbutton = UIButton(type: .system)
    private let tempVideoButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
    
    private func setUI() {
        view.addSubview(tempLogoutbutton)
        tempLogoutbutton.setTitle("로그아웃", for: .normal)
        tempLogoutbutton.tintColor = .white
        tempLogoutbutton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        view.addSubview(tempVideoButton)
        tempVideoButton.setTitle("비디오", for: .normal)
        tempVideoButton.tintColor = .white
        tempVideoButton.addTarget(self, action: #selector(didTapVideoButton), for: .touchUpInside)
        
    }
    
    private func setConstraints() {
        tempLogoutbutton.frame.size = CGSize(width: 80, height: 40)
        tempLogoutbutton.center = view.center
        
        tempVideoButton.frame.size = CGSize(width: 80, height: 40)
        tempVideoButton.center.x = view.center.x
        tempVideoButton.center.y = tempLogoutbutton.center.y - 100
    }
    
    @objc func didTapLogoutButton() {
        LoginStatus.shared.logout()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let window = appDelegate.window
        let rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
    }
    
    @objc func didTapVideoButton() {
        let urlString = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/%E1%84%89%E1%85%A6%E1%86%AB%E1%84%90%E1%85%A5%E1%84%85%E1%85%B3%E1%86%AF+%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9+300%E1%84%80%E1%85%A2%E1%84%85%E1%85%A9+%E1%84%81%E1%85%AA%E1%86%A8%E1%84%81%E1%85%AA%E1%86%A8+%E1%84%8E%E1%85%A2%E1%84%8B%E1%85%AE%E1%84%86%E1%85%A7%E1%86%AB+%E1%84%89%E1%85%A2%E1%86%BC%E1%84%80%E1%85%B5%E1%84%82%E1%85%B3%E1%86%AB+%E1%84%8B%E1%85%B5%E1%86%AF.mp4"
        guard let url = URL(string: urlString) else { return }
        let videoController = VideoController(url: url)
        present(videoController, animated: true)
        
    }

}
