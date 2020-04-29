//
//  AccountViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    private let accountView = AccountView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setConstraints()

    }
    func setNavigationBar() {
           navigationController?.isNavigationBarHidden = false
           navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           navigationController?.navigationBar.shadowImage = UIImage()
           navigationController?.navigationBar.isTranslucent = true
           navigationController?.view.backgroundColor = .setNetfilxColor(name: .black)
           
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 15, weight: .regular)]
           
           let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .plain, target: self, action: #selector(backButtonDidTap))
           backButton.tintColor = .setNetfilxColor(name: .white)
           
           navigationItem.leftBarButtonItem = backButton
           
           title = "계정"
       }
    private func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)

        view.addSubview(accountView)
        
        
    }
    private func setConstraints() {
        
        let inset = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        let topMargin: CGFloat = .dynamicYMargin(margin: (view.frame.height - inset) / 4.5)
        
        accountView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topMargin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            
        }
    }
    @objc func backButtonDidTap() {
           navigationController?.popViewController(animated: true)
       }
    

}
