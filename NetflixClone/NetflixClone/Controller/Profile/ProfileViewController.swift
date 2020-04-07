//
//  ProfileViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//
//싱글톤.쉐어드.겟토큰
import UIKit

enum ProfileRoots {
    case login
    case main
    case manager
    case add
}

struct NetflixUser {
    let name: String
    let isKids: Bool
    let icon: UIImage
}

class ProfileViewController: UIViewController {
    
    var root: ProfileRoots
    
    private let userView0 = UIView()
    private let userView1 = UIView()
    private let userView2 = UIView()
    private let userView3 = UIView()
    private let userView4 = UIView()
    private let titleLabel = UILabel()
    
    var users = [NetflixUser]()
    
    private var userViewArray = [UIView]()
    private var profileViewArray = [ProfileView]()
    
    var userNameArray = [String]()
    var kidsState = true
    
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
        viewSetting()
        setNavigationBar()
        profileList()
        
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
            profileViewArray.forEach {
                $0.setHidden(state: true)
            }
            title = "Netflix를 시청할 프로필을 만들어주세요."
            //            let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(changeButtonDidTap))
            //            completeButton.tintColor = .setNetfilxColor(name: .white)
            //            completeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            //            navigationItem.rightBarButtonItem = completeButton
            navigationItem.leftBarButtonItem = nil
            
        case .main:
            profileViewArray.forEach {
                $0.setHidden(state: true)
            }
            title = "Netflix를 시청할 프로필을 선택하세요."
            
            let changeButton = UIBarButtonItem(title: "변경", style: .plain, target: self, action: #selector(changeButtonDidTap))
            changeButton.tintColor = .setNetfilxColor(name: .white)
            changeButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)], for: .normal)
            navigationItem.rightBarButtonItem = changeButton
        case .manager:
            profileViewArray.forEach {
                $0.setHidden(state: false)
            }
            title = "프로필 관리."
            
            let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(changeButtonDidTap))
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
    private func viewSetting() {
        
        let count = userNameArray.count
        
        for (index, userView) in userViewArray.enumerated() {
            userView.subviews.forEach { $0.removeFromSuperview() }
            
            if index < count {
                let tempProfileView = ProfileView()
                tempProfileView.profileLabel.text = userNameArray[index]
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
    //MARK: API
    func profileList() {

        let bodys: [String: String] = ["profile_name": "profileName", "profile_icon": "profileIcon"]
        guard let jsonList = try? JSONSerialization.data(withJSONObject: bodys) else { return }
        
        guard
            let token = LoginStatus.shared.getToken(),
            let url = URL(string: APIURL.makeProfile.rawValue)
            else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonList
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let data = data else { return print("No Data") }
            print("profileList")
            
            if let res = response as? HTTPURLResponse {
                print(res.statusCode) // 400 -> 성공
            }
            if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("데이터:",data)
                print("리스트제이슨:",jsonObject)
            }
        }
        task.resume()
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
    
    // 변경 버튼 눌렀을 때 네비게이션 타이틀 변경, 완료버튼 생성, 펜슬블러뷰
    @objc private func changeButtonDidTap() {
        profileViewArray.forEach {
            $0.setHidden(state: false)
        }
        rightNavigateionMake()
        
    }
    //메인 프로필에서 완료 버튼 누르면 다시 처음 상태로
    @objc private func completeButtonDidTap() {
        leftNavigationMake()
        
        switch root {
        case .main, .login:
            profileViewArray.forEach {
                $0.setHidden(state: true)
                setNavigationBar()
                print("메인완료")
            }
        case .manager:
            dismiss(animated: true)
            print("프로필관리완료")
        case .add:
            break
        }
    }
}
extension ProfileViewController: ProfilViewDelegate {
    func profileChangeButtonDidTap(blurView: UIView, pencilButton: UIButton) {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            animations: {
                
        })
        let changeVC = ChangeProfileViewController()
        navigationController?.pushViewController(changeVC, animated: true)
        print("체인지")
    }
    //프로필 선택하면 홈화면으로
    func profileButtonDidTap() {
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .coverVertical
        tabBarController.changeRootViewController()
    }
}
// 플러스 버튼을 눌렀을때!!
extension ProfileViewController: AddProfileButtonDelegate {
    func addProfileButtonDidTap() {
        
        let addVC = AddProfileViewController(root: .main)
        navigationController?.pushViewController(addVC, animated: true)
        
    }
}


