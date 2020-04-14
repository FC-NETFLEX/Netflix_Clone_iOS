//
//  ProfileViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//
// 프로필 생성시 두개생김
// iskids 상태 저장되지않음.

import UIKit
import Kingfisher

enum ProfileRoots {
    case login
    case main
    case manager
    case add
}
class ProfileViewController: UIViewController {
    
    var root: ProfileRoots
    
    private let userView0 = UIView()
    private let userView1 = UIView()
    private let userView2 = UIView()
    private let userView3 = UIView()
    private let userView4 = UIView()
    private let titleLabel = UILabel()
    
    private var userIsKids = [Bool]()
    private var userViewArray = [UIView]()
    private var profileViewArray = [ProfileView]()
    
    var userImage = String()
    var userName = String()
    var userNameArray = [String]()
    var userImageArray = [String]()
    var userIDArray = [Int]()
    var userIDNumArray = [Int]()
    
    private var isStateArray = [Bool]()
    
    
    init(root: ProfileRoots) {
        self.root = root
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        reqeustProfileList()
        print(userIDArray)
        print(userIDNumArray)
        
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        switch root {
            
        case .login:
            title = "Netflix를 시청할 프로필을 만들어주세요."
            navigationItem.leftBarButtonItem = nil
            
        case .main:
            title = "Netflix를 시청할 프로필을 선택하세요."
            
            let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
            changeButton.tintColor = .setNetfilxColor(name: .white)
            changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            navigationItem.rightBarButtonItem = changeButton
        case .manager:
            //            print("관리: \(profileViewArray.count)")
            //            profileViewArray.forEach {
            //                $0.setHidden(state: false)
            //            }
            //            title = "프로필 관리."
            
            let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))
            completeButton.tintColor = .setNetfilxColor(name: .white)
            completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            navigationItem.leftBarButtonItem = completeButton
        case .add:
            title = "Netflix를 시청할 프로필을 선택하세요."
            let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
            changeButton.tintColor = .setNetfilxColor(name: .white)
            changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            navigationItem.rightBarButtonItem = changeButton
            //왼쪽 완료버튼 만들기
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let addVC = AddProfileViewController(root: .add)
                let navi = UINavigationController(rootViewController: addVC)
                navi.modalPresentationStyle = .fullScreen
                self.present(navi, animated: true)
            }
        }
    }
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let inset = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        let topMargin: CGFloat = .dynamicYMargin(margin: (view.frame.height - inset) / 8)
        [userView0,userView1,userView2,userView3,userView4].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userView0.topAnchor.constraint(equalTo: guide.topAnchor, constant: topMargin).isActive = true
        userView0.trailingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView0.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView1.topAnchor.constraint(equalTo: guide.topAnchor, constant: topMargin).isActive = true
        userView1.leadingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView1.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView2.topAnchor.constraint(equalTo: userView0.bottomAnchor, constant: margin * 4).isActive = true
        userView2.trailingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView2.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView3.topAnchor.constraint(equalTo: userView0.bottomAnchor, constant: margin * 4).isActive = true
        userView3.leadingAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView3.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
        userView4.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        userView4.topAnchor.constraint(equalTo: userView2.bottomAnchor, constant: margin * 4).isActive = true
        userView4.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.33).isActive = true
        
    }
    
    private func setImage(stringURL: String, button: UIButton) {
        guard let url = URL(string: stringURL) else { return }
        KingfisherManager.shared.retrieveImage(with: url, completionHandler: {
            result in
            switch result {
            case .success(let imageResult):
                button.setImage(imageResult.image, for: .normal)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func viewSetting() {
        let count = userNameArray.count
        
        for (index, userView) in userViewArray.enumerated() {
            userView.subviews.forEach { $0.removeFromSuperview() }
            
            if index < count {
                let tempProfileView = ProfileView()
                tempProfileView.tag = index
                tempProfileView.profileLabel.text = userNameArray[index]
                let button = tempProfileView.profileButton
                setImage(stringURL: userImageArray[index], button: button)
                userView.addSubview(tempProfileView)
                profileViewArray.append(tempProfileView)
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
                tempAddView.heightAnchor.constraint(equalTo: userView0.widthAnchor).isActive = true
                
            }
        }
    }
    
    private func rightNavigateionMake() {
        title = "프로필 관리"
        navigationItem.rightBarButtonItem = nil
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))
        completeButton.tintColor = .setNetfilxColor(name: .white)
        completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
        navigationItem.leftBarButtonItem = completeButton
        
        
        
    }
    private func leftNavigationMake() {
        title = "Netflix를 시청할 프로필을 선택하세요."
        navigationItem.leftBarButtonItem = nil
        let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
        changeButton.tintColor = .setNetfilxColor(name: .white)
        changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
        navigationItem.rightBarButtonItem = changeButton
        
    }
    //    MARK: API
    func reqeustProfileList() {

        guard
            let token = LoginStatus.shared.getToken(),
            let url = URL(string: APIURL.makeProfile.rawValue)
            else { return }
           print(token)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
      
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, _, _) in
            guard
                let data = data,
                let profileLists = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                else { return }
            // 양중창이 수정함
            self.userIDArray.removeAll()
            // 양중창이 수정함
            self.userNameArray.removeAll()
            self.userImageArray.removeAll()
            
            for profileList in profileLists {
                guard
                    let id = profileList["id"] as? Int,
                    let name = profileList["profile_name"] as? String,
                    let iskids = profileList["is_kids"] as? Bool,
                    let profileIcons = profileList["profile_icon"] as? [String: Any]
                    else { return}
                
                self.userIDArray.append(id)
                self.userNameArray.append(name)
                self.userIsKids.append(iskids)
                
                guard
                    let idNum = profileIcons["id"] as? Int,
                    let iconURL = profileIcons["icon"] as? String
                    else { return print("icon")}
            
                self.userIDNumArray.append(idNum)
                self.userImageArray.append(iconURL)
                self.userImage = iconURL
            }
            
            DispatchQueue.main.async {
                self.viewSetting()
                if self.root == .manager {
                    self.profileViewArray.forEach {
                        $0.setHidden(state: false)
                    }
                    self.title = "프로필 관리."
                }
            }
            
        }
        task.resume()
    }
    
    
    @objc func changeButtonDidTap() {
        profileViewArray.forEach {
            $0.setHidden(state: false)
        }
        rightNavigateionMake()
        
    }
    
    @objc private func completeButtonDidTap() {
        leftNavigationMake()
        
        switch root {
        case .main, .login:
            profileViewArray.forEach {
                $0.setHidden(state: true)
                setNavigationBar()
            }
        case .manager, .add:
            dismiss(animated: true)
        }
    }
}
extension ProfileViewController: ProfilViewDelegate {
    
    func profileButtonDidTap(tag: Int) {
        // 양중창이 수정함
        LoginStatus.shared.selectedProfile(profileID: userIDArray[tag])
        // 양중창이 수정함
        
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .coverVertical
        tabBarController.changeRootViewController()
    }
    
    func profileChangeButtonDidTap(tag: Int, blurView: UIView, pencilButton: UIButton) {
        print("-----------------------------변경태그", tag)
        let selectView = profileViewArray[tag]
        guard
            let selectViewName = selectView.profileLabel.text,
            let selectViewImage = selectView.profileButton.imageView?.image
            else { return }
        print("셀렉",selectViewName, selectViewImage)
        
        
        //        UIView.animateKeyframes(
        //            withDuration: 0.3,
        //            delay: 0,
        //            animations: {
        //                UIView.addKeyframe(
        //                withRelativeStartTime: 0.0, relativeDuration: 0.3) {
        //                    let selectView = self.profileViewArray[tag]
        //                    selectView.center.x = self.view.center.x
        //                    selectView.center.y = self.view.center.y
        //
        //                    print("애니메이션", selectView)
        //                }
        //
        //
        //        }) { _ in
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //                let changeVC = ChangeProfileViewController()
        //                changeVC.isKids = self.kidState
        //                changeVC.profileIcon = self.userImage
        //                changeVC.addProfileView.nickNameTextfield.attributedPlaceholder = NSAttributedString(string: self.userName, attributes: [NSAttributedString.Key.foregroundColor : UIColor.setNetfilxColor(name: .white)])
        //                self.navigationController?.pushViewController(changeVC, animated: true)
        //            }
        //
        //        }
        let changeVC = ChangeProfileViewController()
        changeVC.userID = userIDArray[tag]
        changeVC.profileName = userNameArray[tag]
        changeVC.profileIcon = selectViewImage
        changeVC.isKids = userIsKids[tag]
        changeVC.profileIconNum = userIDNumArray[tag]
        changeVC.addProfileView.nickNameTextfield.attributedPlaceholder = NSAttributedString(string: selectViewName, attributes: [NSAttributedString.Key.foregroundColor : UIColor.setNetfilxColor(name: .white)])
        navigationController?.pushViewController(changeVC, animated: true)
        
        print(selectViewImage)
        print(selectViewName)
    }
    
}


extension ProfileViewController: AddProfileButtonDelegate {
    func addProfileButtonDidTap() {
        
        let addVC = AddProfileViewController(root: .main)
        navigationController?.pushViewController(addVC, animated: true)
    }
}


