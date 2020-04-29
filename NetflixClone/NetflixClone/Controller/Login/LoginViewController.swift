//
//  LoginViewController.swift
//  NetFlexFrame
//
//  Created by MyMac on 2020/03/22.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let rootView = LoginView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        setNavigationBar()
        setUI()
        
    }
    
    private func setUI() {
        rootView.delegate = self
    }
    
    private func setNavigationBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popAction))
        backButton.tintColor = .setNetfilxColor(name: .white)
        navigationItem.leftBarButtonItem = backButton
//        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let imageView = UIImageView()
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let customerCenterButton = UIBarButtonItem(title: "고객센터", style: .plain, target: self, action: #selector(touchCustomerCenterButton))
        customerCenterButton.tintColor = .white
        navigationItem.rightBarButtonItem = customerCenterButton
    }
    
    
    
    
    
    @objc private func touchCustomerCenterButton(_ sender: UIButton) {
        print("고객센터")
    }
    
    
    @objc private func popAction() {
        print(#function)
        guard !rootView.isLoading else { return }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


extension LoginViewController: LoginViewDelegate {
    
    func login(email: String, password: String) {
        let param = ["email": email, "password": password]
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
        
        guard let url = APIURL.logIn.makeURL() else { return }
        
        APIManager().request(
            url: url,
            method: .post,
            body: data,
            completionHandler: {
                [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.rootView.isLoading = false
                    UIAlertController(
                        title: "로그인",
                        message: error.localizedDescription,
                        preferredStyle: .alert)
                        .noticePresent(viewController: self)
                    
                    
                case .success(let data):
                    self.rootView.isLoading = false
                    guard
                        let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let token = result["token"] as? String
                        else {
                            UIAlertController(
                                title: "로그인",
                                message: "아이디 또는 비밀번호를 확인해주세요.",
                                preferredStyle: .alert)
                                .noticePresent(viewController: self)
                            return
                    }
                    
                    let user = User(email: email, token: token)
                    LoginStatus.shared.login(user: user)
                    let profileVC = ProfileViewController(root: .login)
                    let navi = UINavigationController(rootViewController: profileVC)
                    navi.modalPresentationStyle = .fullScreen
                    self.present(navi, animated: true)
                    
                }
        })
    }
    
    
}

