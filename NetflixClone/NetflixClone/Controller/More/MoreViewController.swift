//
//  MoreViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    private let tempLogoutbutton = UIButton(type: .system)

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
        
    }
    
    private func setConstraints() {
        tempLogoutbutton.frame.size = CGSize(width: 80, height: 40)
        tempLogoutbutton.center = view.center
    }
    
    @objc func didTapLogoutButton() {
        LoginStatus.shared.logout()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let window = appDelegate.window
        window?.rootViewController = LaunchScreenViewController()
        window?.makeKeyAndVisible()
        
    }
    

}
