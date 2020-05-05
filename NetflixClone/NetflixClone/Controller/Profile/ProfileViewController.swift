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
    
    let stackViewArray = [UIStackView(), UIStackView(), UIStackView()]
    var userProfileList = [ProfileList]()
    var userIconList = [ProfileIcons]()
    
    private var userIsKids = [Bool]()
    private var userViewArray = [UIView]()
    private var profileViewArray = [ProfileView]()
    private var buttonView = UIView()
  
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
        
    }
    //MARK: SETUI
    private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stackViewArray.forEach {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .center
            view.addSubview($0)
        }
        
    }
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 15, weight: .regular)]
        
        switch root {
            
        case .login:
            title = "Netflix를 시청할 프로필을 만들어주세요."
            navigationItem.leftBarButtonItem = nil
            
        case .main:
            title = "Netflix를 시청할 프로필을 선택하세요."
            
            let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
            changeButton.tintColor = .setNetfilxColor(name: .white)
            changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 14, weight: .heavy)], for: .normal)
            navigationItem.rightBarButtonItem = changeButton
        case .manager:
            let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))
            completeButton.tintColor = .setNetfilxColor(name: .white)
            completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 14, weight: .heavy)], for: .normal)
            navigationItem.leftBarButtonItem = completeButton
        case .add:
            title = "Netflix를 시청할 프로필을 선택하세요."
            let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
            changeButton.tintColor = .setNetfilxColor(name: .white)
            changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 14, weight: .heavy)], for: .normal)
            navigationItem.rightBarButtonItem = changeButton
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.imageSetting()
                
            }
        }
    }
    private func imageSetting() {
        
        let addVC = AddProfileViewController(root: .add)
        
        switch userIconList.isEmpty {
        case true:
            addVC.randomSetImage = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/profile/icon/icon3.png"
            addVC.randomIndex = 3
            
        case false:
            guard let imageIndex = (0..<self.userIconList.count).randomElement() else { return }
            addVC.randomSetImage = self.userIconList[imageIndex].iconURL
            addVC.randomIndex = self.userIconList[imageIndex].idNum
        }
        
        let navi = UINavigationController(rootViewController: addVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
    
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let topMargin: CGFloat = .dynamicYMargin(margin: (view.frame.height / 8))
        
        stackViewArray.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.17).isActive = true
        }
        stackViewArray[0].topAnchor.constraint(equalTo: guide.topAnchor, constant: topMargin).isActive = true
        stackViewArray[1].centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        stackViewArray[2].bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -topMargin).isActive = true

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
    
    var profileViews = [UIView]()
    func stackViewSetting() {
        let guide = view.safeAreaLayoutGuide
        let count = userProfileList.count

        
        profileViews.forEach { tempView in
            tempView.removeFromSuperview()
        }
        
        profileViews.removeAll()
        profileViewArray.removeAll()
        
        for (index, value) in userProfileList.enumerated() {
            let tempStackView = stackViewArray[index / 2]
            let profileView = ProfileView()
            profileView.profileLabel.text = value.name
            profileView.tag = index
            let button = profileView.profileButton
            setImage(stringURL: userIconList[index].iconURL, button: button)
            profileView.delegate = self
            tempStackView.addArrangedSubview(profileView)
            profileViewArray.append(profileView)
            profileViews.append(profileView)
           
            profileView.translatesAutoresizingMaskIntoConstraints = false
         
//            profileView.centerXAnchor.constraint(equalTo: tempStackView.centerXAnchor).isActive = true
            profileView.widthAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.17).isActive = true
            profileView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.17).isActive = true
        }
        
        if count < 5 {
            let tempStackView = stackViewArray[count / 2]
            let addProfileView = AddProfileButtonView()
            addProfileView.delegate = self
            tempStackView.addArrangedSubview(addProfileView)
            profileViews.append(addProfileView)
            buttonView = addProfileView
            
            addProfileView.translatesAutoresizingMaskIntoConstraints = false

//            addProfileView.centerXAnchor.constraint(equalTo: tempStackView.centerXAnchor).isActive = true
            addProfileView.widthAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.17).isActive = true
            addProfileView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.17).isActive = true
        }
    }
    
    private func rightNavigateionMake() {
        title = "프로필 관리"
        navigationItem.rightBarButtonItem = nil
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))
        completeButton.tintColor = .setNetfilxColor(name: .white)
        completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 14, weight: .heavy)], for: .normal)
        navigationItem.leftBarButtonItem = completeButton
        
        
        
    }
    private func leftNavigationMake() {
        title = "Netflix를 시청할 프로필을 선택하세요."
        navigationItem.leftBarButtonItem = nil
        let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
        changeButton.tintColor = .setNetfilxColor(name: .white)
        changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 14, weight: .heavy)], for: .normal)
        navigationItem.rightBarButtonItem = changeButton
        
    }
    //MARK: API - 요청
    func reqeustProfileList() {
        
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.makeProfile.makeURL()
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
            self.userIconList.removeAll()
            self.userProfileList.removeAll()
            
            
            for profileList in profileLists {
                guard
                    let id = profileList["id"] as? Int,
                    let name = profileList["profile_name"] as? String,
                    let iskids = profileList["is_kids"] as? Bool,
                    let profileIcons = profileList["profile_icon"] as? [String: Any]
                    else { return }
                
                
                self.userProfileList.append(ProfileList(id: id, name: name, iskids: iskids))
                
                
                guard
                    let idNum = profileIcons["id"] as? Int,
                    let iconURL = profileIcons["icon"] as? String
                    else { return }
                
                
                self.userIconList.append(ProfileIcons(idNum: idNum, iconURL: iconURL))
                
                
            }
            
            DispatchQueue.main.async {
                self.stackViewSetting()
                if self.root == .manager {
                    self.profileViewArray.forEach {
                        $0.setHidden(state: false)
                    }
                    self.title = "프로필 관리"
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
        profileViewArray.forEach {
            $0.setHidden(state: true)
            setNavigationBar()
        }
        self.dismiss(animated: true)

    }
}

extension ProfileViewController: ProfilViewDelegate {
    
    func profileButtonDidTap(tag: Int) {
        let userProfile = userProfileList[tag]
        let icon = userIconList[tag]
        guard let imageURL = URL(string: icon.iconURL) else { return }
        let id = userProfile.id
        let name = userProfile.name
        let profile = Profile(id: id, name: name, imageURL: imageURL)
        LoginStatus.shared.selectedProfile(profile: profile)
        // 양중창이 수정함
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .coverVertical
        tabBarController.changeRootViewController()
    }
    
    func profileChangeButtonDidTap(tag: Int, blurView: UIView, pencilButton: UIButton) {
        profileViewArray.forEach {
            $0.setHidden(state: true)
        }
        
        let selectView = profileViewArray[tag]
        guard
            let selectViewName = selectView.profileLabel.text,
            let selectViewImage = selectView.profileButton.imageView?.image
            else { return }
        
        let topMargin: CGFloat = .dynamicYMargin(margin: (view.frame.height / 5.5))
        let center = CGPoint(x: view.center.x, y: view.safeAreaInsets.top + topMargin + (selectView.frame.height / 2))
        
        let superView = stackViewArray[tag / 2]
        let selectedViewCenter = CGPoint(x: superView.frame.minX + selectView.center.x, y: superView.frame.minY + selectView.center.y)
        let result = CGPoint(x: center.x - selectedViewCenter.x, y: center.y - selectedViewCenter.y)
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
   
            for (_,value) in self.profileViewArray.enumerated() {
                if value == selectView {
                    value.profileLabel.isHidden = true
                    self.buttonView.alpha = 0
                    
                } else {
                    value.alpha = 0
                    self.buttonView.alpha = 0
                }
            }
            selectView.transform = .init(translationX: result.x, y: result.y)

        })
        { _ in
            let changeVC = ChangeProfileViewController()
            changeVC.userID = self.userProfileList[tag].id
            changeVC.profileName = self.userProfileList[tag].name
            changeVC.profileIcon = selectViewImage
            changeVC.isKids = self.userProfileList[tag].iskids
            changeVC.profileIconNum = self.userIconList[tag].idNum
            changeVC.addProfileView.nickNameTextfield.attributedPlaceholder = NSAttributedString(string: selectViewName, attributes: [NSAttributedString.Key.foregroundColor : UIColor.setNetfilxColor(name: .white)])
            
            
            self.navigationController?.modalTransitionStyle = .crossDissolve
            self.navigationController?.modalPresentationStyle = .none
            self.navigationController?.pushViewController(changeVC, animated: false)
            
            
            selectView.transform = .identity
            self.profileViewArray.forEach { $0.alpha = 1 }

        }

    }
    
}


extension ProfileViewController: AddProfileButtonDelegate {
    func addProfileButtonDidTap() {
        imageSetting()
    }
}


