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
import Kingfisher

enum ChangeRoots {
    case main
    case add
    case manager
}

class AddProfileViewController: UIViewController {
    
    var root: ChangeRoots
    private var addProfileBottom: NSLayoutConstraint?
    let addProfileView = AddProfileView()
    private let kidsView = KidsCustomView()
    private var imageID: Int?
    var randomSetImage = String()
    var randomIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageID = randomIndex
        
        setUI()
        setConstraints()
        setNavigationBar()
        keyboad()
        settingImage()
        
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 17, weight: .regular)]
        
        navigationItem.title = "프로필 만들기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton(_:)))
        cancelButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton(_:)))
        saveButton.tintColor = .gray
        navigationItem.rightBarButtonItem = saveButton
        
    }
     //MARK: SETUI
    private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [addProfileView,kidsView].forEach {
            view.addSubview($0)
        }
        addProfileView.delegate = self
        
        addProfileView.newProfileButton.setImage(UIImage(named: randomSetImage), for: .normal)
        addProfileView.nickNameTextfield.delegate = self
        
        kidsView.delegate = self
    }
    private func keyboad() {
        // 키보드가 보여질때 showKeyboardAction 실행
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboardAction), name: NSNotification.Name(rawValue: UIResponder.keyboardWillShowNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboardAction), name: NSNotification.Name(rawValue: UIResponder.keyboardWillHideNotification.rawValue), object: nil)
    }
    
    @objc private func showKeyboardAction() {
        addProfileBottom?.constant = 0
        kidsView.alpha = 0
        
    }
    @objc private func hiddenKeyboardAction() {
        addProfileBottom?.constant = 70
        kidsView.alpha = 1
    }
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let padding: CGFloat = 20
        let spacing: CGFloat = 70
        [addProfileView,kidsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addProfileView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        addProfileView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        addProfileView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3).isActive = true
        addProfileBottom = addProfileView.bottomAnchor.constraint(equalTo: guide.centerYAnchor, constant: spacing)
        addProfileBottom?.isActive = true
        
        kidsView.topAnchor.constraint(equalTo: addProfileView.bottomAnchor, constant: padding).isActive = true
        kidsView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding).isActive = true
        kidsView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding).isActive = true
        kidsView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func settingImage() {
        let button = addProfileView.newProfileButton
        setImage(stringURL: randomSetImage, button: button)
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        print("프로필만들기취소")
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton(_ sender: Any) {
//        print("프로필 만들기 저장")
        
//        if let navi = presentingViewController as? UINavigationController, let vc = navi.viewControllers.first as?
        if let navi = presentingViewController as? UIViewController {
            print("프로필 만들기 저장")
            //            vc.root = .main
            profileCreate()
            presentingViewController?.dismiss(animated: true)
        } else {
            for vc in navigationController!.viewControllers.reversed() {
                if let profileVC = vc as? ProfileViewController {
                    profileVC.root = .main
                    profileCreate()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    //MARK: API - 추가
    private func profileCreate() {
        guard let profileName = addProfileView.nickNameTextfield.text else { return }
        guard let profileIcon = imageID else { return }
        let isKids = kidsView.kidsSwitch.isOn
        
        let bodys: [String: Any] = ["profile_name": profileName, "profile_icon": profileIcon, "is_kids": isKids]
        guard let jsonToDO = try? JSONSerialization.data(withJSONObject: bodys) else { return }
        
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.makeProfile.makeURL()
            else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonToDO
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let data = data else { return print("No Data") }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            
        }
        task.resume()
    }
    // 키즈용 alert
    private func alertAction() {
        let alert = UIAlertController(title: nil, message: "본 프로필의 연령 제한이 풀려 이제 모든 등급의 영화와 TV 프로그램을 시청할 수 있게 됩니다.", preferredStyle: .alert)
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
        imageVC.delegate = self
        imageVC.modalPresentationStyle = .fullScreen
        present(imageVC,animated: true)
    }
}

extension AddProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("선택")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}


extension AddProfileViewController: ProfileImageViewControllerDelegate {
    func setImage(image: UIImage, imageID: Int) {
        
        addProfileView.newProfileButton.setImage(image, for: .normal)
        print(image)
        self.imageID = imageID
    }
}
