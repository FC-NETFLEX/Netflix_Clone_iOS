//
//  ProfileViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
   private let userView0 = UIView()
   private let userView1 = UIView()
   private let userView2 = UIView()
   private let userView3 = UIView()
   private let userView4 = UIView()
    
   private var profileViewArray = [UIView]()
   private var userNameArray = ["유꽁"]
    
   private var isStateArray = [Bool]()
    
   private let changeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSetting()
        
    }
   private func setUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [userView0,userView1,userView2,userView3,userView4].forEach {
            profileViewArray.append($0)
            view.addSubview($0)
        }
        
        
        changeButton.setTitle("변경", for: .normal)
        changeButton.addTarget(self, action: #selector(changeButtonDidTap), for: .touchUpInside)
        changeButton.setTitleColor(.white, for: .normal)
        view.addSubview(changeButton)
        
    }
    
    
    
   private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 10
        [userView0,userView1,userView2,userView3,userView4,changeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userView0.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 15).isActive = true
        userView0.trailingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView0.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView1.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 15).isActive = true
        userView1.leadingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView1.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView2.topAnchor.constraint(equalTo: userView0.bottomAnchor, constant: margin * 5).isActive = true
        userView2.trailingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView2.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView3.topAnchor.constraint(equalTo: userView0.bottomAnchor, constant: margin * 5).isActive = true
        userView3.leadingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView3.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView4.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView4.topAnchor.constraint(equalTo: userView2.bottomAnchor, constant: margin * 5).isActive = true
        
        changeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 2).isActive = true
        changeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin * 2).isActive = true
        
        
    }
    private func viewSetting() {
        let count = userNameArray.count
        
        for (index, userView) in profileViewArray.enumerated() {
            
            userView.subviews.forEach { $0.removeFromSuperview() }
            
            if index < count {
                let tempProfileView = ProfileView()
                tempProfileView.profileLabel.text = userNameArray[index]
                tempProfileView.delegate = self
                userView.addSubview(tempProfileView)
                
                tempProfileView.translatesAutoresizingMaskIntoConstraints = false
                tempProfileView.topAnchor.constraint(equalTo: userView.topAnchor).isActive = true
                tempProfileView.leadingAnchor.constraint(equalTo: userView.leadingAnchor).isActive = true
                tempProfileView.trailingAnchor.constraint(equalTo: userView.trailingAnchor).isActive = true
                tempProfileView.bottomAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
                
            } else if index == count {
                let tempAddView = AddProfileButtonView()
                tempAddView.delegate = self
                userView.addSubview(tempAddView)
                
                tempAddView.translatesAutoresizingMaskIntoConstraints = false
                tempAddView.topAnchor.constraint(equalTo: userView.topAnchor).isActive = true
                tempAddView.leadingAnchor.constraint(equalTo: userView.leadingAnchor).isActive = true
                tempAddView.trailingAnchor.constraint(equalTo: userView.trailingAnchor).isActive = true
                tempAddView.bottomAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
                tempAddView.heightAnchor.constraint(equalTo: profileViewArray[0].heightAnchor).isActive = true
            }
        }
    }
    
    
    
    // 변경 버튼 눌렀을 때 블러뷰, 펜슬버튼 생기도록
   private var viewsState = true
    @objc private func changeButtonDidTap() {
        
        viewsState.toggle()
        //        profileViewArray.forEach {
        //            $0.setHidden(state: viewsState)
        //        }
        print("changeButtonDidTap")
    }
    
}
extension ProfileViewController: ProfilViewDelegate {
    func profileChangeButtonDidTap(blurView: UIView, pencilButton: UIButton) {
        print("체인지")
    }
    
    func profileButtonDidTap() {
        print("프로필")
    }
    
}
// 플러스 버튼을 눌렀을때!!
extension ProfileViewController: AddProfileButtonDelegate {
    func addProfileButtonDidTap() {
        print("추가")
        let changeVC = ChangeProfileViewController()
        changeVC.modalPresentationStyle = .fullScreen
        present(changeVC, animated:  true)
        
    }
}

