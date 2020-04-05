//
//  LaunchScreenViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//


import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let rootView = LaunchScreanView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        setNavigationBar()
        
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let logoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        logoButton.setBackgroundImage(UIImage(named: "Logo"), for: .normal)
        logoButton.addTarget(self, action: #selector(touchNetflixButton(_:)), for: .touchUpInside)
        logoButton.imageView?.contentMode = .scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButton)
        
        let signUpButton = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(touchSignUpButton(_:)))
        signUpButton.tintColor = .white
        let personalInfoButton = UIBarButtonItem(title: "개인정보", style: .plain, target: self, action: #selector(touchPersonalInfoButton(_:)))
        
        personalInfoButton.tintColor = .white
        navigationItem.rightBarButtonItems = [signUpButton, personalInfoButton]
    }
    
   @objc private func touchNetflixButton(_ sender: UIButton) {
       print("넷플릭스 이미지 들어가는 버튼")
   }
   
   @objc private func touchSignUpButton(_ sender: UIButton) {
       let signUpVC = SignUpViewController()
       navigationController?.pushViewController(signUpVC, animated: true)
   }
   
   @objc private func touchPersonalInfoButton(_ sender: UIButton) {
       print("개인정보")
   }
   
   
    
}




extension LaunchScreenViewController: LaunchScreanViewDelegate {
    func pushLogInViewController() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
}
