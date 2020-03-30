//
//  ProfileViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//
// 데이터 들어와 뷰에 나타나지 않음.
import UIKit

class ProfileViewController: UIViewController {
    
    private let userView0 = UIView()
    private let userView1 = UIView()
    private let userView2 = UIView()
    private let userView3 = UIView()
    private let userView4 = UIView()
    private let titleLabel = UILabel()
    
    
    private var userViewArray = [UIView]()
    private var profileViewArray = [ProfileView]()
    var userNameArray = ["데이터"]
    
    private var isStateArray = [Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSetting()
        
    }
    private func setUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [userView0,userView1,userView2,userView3,userView4].forEach {
            userViewArray.append($0)
            view.addSubview($0)
        }
        
        
        
    }
    func setNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.topItem?.title = "Netflix를 시청할 프로필을 선택하세요."
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
        changeButton.tintColor = .setNetfilxColor(name: .white)
        changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
        navigationItem.rightBarButtonItem = changeButton
        
        
        
    }
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 10
        [userView0,userView1,userView2,userView3,userView4].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userView0.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 10).isActive = true
        userView0.trailingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView0.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView1.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 10).isActive = true
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
        
        
        
    }
    private func viewSetting() {
        let count = userNameArray.count
        
        for (index, userView) in userViewArray.enumerated() {
            userView.subviews.forEach { $0.removeFromSuperview() }
            
            if index < count {
                let tempProfileView = ProfileView()
                tempProfileView.profileLabel.text = userNameArray[index]
                userView.addSubview(tempProfileView)
                profileViewArray.append(tempProfileView)
                print(tempProfileView)
                tempProfileView.delegate = self
                
                
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
                tempAddView.heightAnchor.constraint(equalTo: userViewArray[0].heightAnchor).isActive = true
            }
        }
    }
    
    
    
    // 변경 버튼 눌렀을 때 네비게이션 타이틀 변경, 완료버튼 생성, 펜슬블러뷰
    private var viewsState = true
    @objc private func changeButtonDidTap() {
        viewsState.toggle()
        profileViewArray.forEach {
            $0.setHidden(state: viewsState)
            navigationController?.navigationBar.topItem?.title = "프로필 관리"
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
           
            let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))
            completeButton.tintColor = .setNetfilxColor(name: .white)
            completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            navigationItem.leftBarButtonItem = completeButton
            navigationItem.rightBarButtonItem = nil
            
        }
        
    }
    //완료 버튼 누르면 다시 처음 상태로
    @objc private func completeButtonDidTap() {
        viewsState.toggle()
        profileViewArray.forEach {
            $0.setHidden(state: viewsState)
            setNavigationBar()
            navigationItem.leftBarButtonItem = nil
        }
    }
}
extension ProfileViewController: ProfilViewDelegate {
    func profileChangeButtonDidTap(blurView: UIView, pencilButton: UIButton) {
        let changeVC = ChangeProfileViewController()
        changeVC.modalPresentationStyle = .pageSheet
        present(changeVC, animated: true)
        print("체인지")
    }
    
    func profileButtonDidTap() {
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let tabBarController = TabBarController()
            tabBarController.modalTransitionStyle = .crossDissolve
            tabBarController.changeRootViewController()
        }
        print("프로필")
    }
    
}
// 플러스 버튼을 눌렀을때!!
extension ProfileViewController: AddProfileButtonDelegate {
    func addProfileButtonDidTap() {
        
        let changeVC = ChangeProfileViewController()
        navigationController?.pushViewController(changeVC, animated: true)
       
    }
}


