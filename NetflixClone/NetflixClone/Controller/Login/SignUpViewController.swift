//
//  SignUpViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let rootView = SignUpView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        setNavigationBar()
        setUI()
    }
    
    private func setUI() {
        rootView.delegate = self
    }
    
    private func setNavigationBar() {
        // 투명
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popAction))
        
        backButton.tintColor = .setNetfilxColor(name: .white)
//        backButton.title = ""
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = backButton
        
        let imageView = UIImageView()
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    @objc private func popAction() {
        print(#function)
        guard !rootView.isLoading else { return }
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController: SignUpViewDelegate {
    func signUp(email: String, passWord: String) {
        
        
        let param = ["email": email, "password": passWord]
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
        guard let url = APIURL.signUp.makeURL() else { return }
        
        APIManager().request(url: url, method: .post, body: data, completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error) :
                // 에러 처리
                self.rootView.isLoading = false
                print(error.localizedDescription)
                
            case .success(let data):
                // 회원가입이 완료된것이 아니라 서버와의 통신이 성공한거
                self.rootView.isLoading = false
                guard let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                
                // 회원가입 실패
                guard let _ = data["id"] as? Int else {
                    
                    if let notice = data["email"] as? [String] {
                        UIAlertController(title: "회원가입", message: notice.first ?? "다시 시도해 주세요", preferredStyle: .alert).noticePresent(viewController: self)
                    }
                    return
                }
                
                // 회원가입 성공
                UIAlertController(title: "회원가입", message: "회원가입 완료", preferredStyle: .alert).noticePresent(viewController: self, completion: {
                    [weak self]  in
                    let loginVC = LoginViewController()
                    self?.navigationController?.pushViewController(loginVC, animated: true)
                    
                })
                
            }
        })
    }
    
    
}
