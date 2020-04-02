//
//  ChangeProfileViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//
// 1. 텍스트필드 눌렀을때 화면 움직이게
// 2.
import UIKit

enum ChangeRoots {
    case main
    case add
    case manager
}
class AddProfileViewController: UIViewController {
    
    var root: ChangeRoots
    private let addProfileView = AddProfileView()
    private let kidsView = KidsCustomView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        setNavigationBar()
        profileCreate()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addProfileView.nickNameTextfield.becomeFirstResponder()
        
    }
    init(root: ChangeRoots) {
        self.root = root
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        navigationItem.title = "프로필 만들기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton(_:)))
        cancelButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton(_:)))
        saveButton.tintColor = .gray
        navigationItem.rightBarButtonItem = saveButton
        
    }
    private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [addProfileView,kidsView].forEach {
            view.addSubview($0)
        }
        addProfileView.delegate = self
        addProfileView.nickNameTextfield.delegate = self
        
        kidsView.delegate = self
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 20
        let spacing: CGFloat = 80
        [addProfileView,kidsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addProfileView.topAnchor.constraint(equalTo: guide.topAnchor, constant: padding * 2).isActive = true
        addProfileView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        addProfileView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        addProfileView.bottomAnchor.constraint(equalTo: guide.centerYAnchor, constant: spacing).isActive = true
        
        kidsView.topAnchor.constraint(equalTo: addProfileView.bottomAnchor).isActive = true
        kidsView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding).isActive = true
        kidsView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding).isActive = true
        kidsView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        print("프로필만들기취소")
        switch root {
        case .main,.manager:
            for vc in navigationController!.viewControllers.reversed() {
                if let profileVC = vc as? ProfileViewController {
                    profileVC.root = .main
                    navigationController?.popViewController(animated: true)
                }
            }
        case .add:
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func didTapSaveButton(_ sender: Any) {
        
        guard let userName = addProfileView.nickNameTextfield.text, !userName.isEmpty else { return }
        let kidsState = kidsView.kidsSwitch.isOn
        
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                switch root {
                case .main,.manager:
                    //                    let tempUser = NetflixUser(token: "Asd", email: "aaaa", isKids: kidsState, image: <#T##UIImage#>)
                    //                    profileVC.users.append(tempU ser)
                    profileVC.root = .main
                    profileVC.userNameArray.append(userName)
                    profileVC.kidsState = kidsState
                    navigationController?.popViewController(animated: true)
                case .add:
                    profileVC.root = .main
                    profileVC.userNameArray.append(userName)
                    profileVC.kidsState = kidsState
                    navigationController?.popViewController(animated: true)
                }
            }
            print(userName,"키즈용: ",kidsState)
        }
    }
    //MARK: API
    private func profileCreate() {
        guard let userName = addProfileView.nickNameTextfield.text else { return }
        let isKids = kidsView.kidsSwitch.isOn
        
        let bodys: [String: Any] = ["profile_icon": 12, "profile_name": userName, "is_kids": isKids]
        guard let jsonToDO = try? JSONSerialization.data(withJSONObject: bodys) else { return }
        
        guard
            let token = LoginStatus.shared.getToken(),
            let url = URL(string: APIURL.makeProfile.rawValue)
            else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonToDO
        print(token)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let data = data else { return print("No Data") }
            print("create")
            
            if let res = response as? HTTPURLResponse {
                print(res.statusCode) // 400 -> 성공
            }
            if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print(data)
                print(jsonObject)
            }
        }
        task.resume()
    }
    // 키즈용 alert
    func alertAction() {
        let alert =  UIAlertController(title: nil, message: "본 프로필의 연령 제한이 풀려 이제 모든 등급의 영화와 TV 프로그램을 시청할 수 있게 됩니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
extension AddProfileViewController: KidsCustomViewDelegate,AddProfileViewDelegate {
    func kidsSwitchDidTap() {
        alertAction()
    }
    func newProfileButtonDidTap() {
        print("이미지선택")
        let imageVC = ProfileImageViewController()
        imageVC.modalPresentationStyle = .overCurrentContext
        present(imageVC,animated: true)
    }
    
}


extension AddProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("선택")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("프로필만들기텍스트필드")
        return view.endEditing(true)
    }
}


