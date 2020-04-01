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
class ChangeProfileViewController: UIViewController {
    
    var root: ChangeRoots
    private let addProfileView = AddProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        setNavigationBar()
        
    }
    init(root: ChangeRoots) {
           self.root = root
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setNavigationBar() {
        
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
        [addProfileView].forEach {
            view.addSubview($0)
        }
        addProfileView.delegate = self
        addProfileView.nickNameTextfield.delegate = self
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 20
        [addProfileView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addProfileView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        addProfileView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding).isActive = true
        addProfileView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding).isActive = true
        addProfileView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding * 2).isActive = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        print("프로필만들기취소")
        for vc in navigationController!.viewControllers.reversed() {
             if let profileVC = vc as? ProfileViewController {
            switch root {
            case .main,.manager:
               profileVC.root = .main
                navigationController?.popViewController(animated: true)
            case .add:
                profileVC.root = .main
                navigationController?.popViewController(animated: true)
                }
            }
        }
//        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSaveButton(_ sender: Any) {
        
        guard let userName = addProfileView.nickNameTextfield.text, !userName.isEmpty else { return }
        let kidsState = addProfileView.kidsSwitch.isOn
        
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
            switch root {
            case .main,.manager:
                profileVC.root = .main
                profileVC.userNameArray.append(userName)
                profileVC.kidsState = kidsState
                navigationController?.popViewController(animated: true)
            case .add:
                profileVC.root = .main
                navigationController?.popViewController(animated: true)
                }
            }
        }
        //        guard let navi = presentingViewController as? ProfileViewController else { return }
//        navi.userNameArray.append(userName)
//        navigationController?.popViewController(animated: true)
        
        print(userName,"키즈용:",kidsState)
//          print(navi.userNameArray)
        
        
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
extension ChangeProfileViewController: AddProfileViewDelegate {
    
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

extension ChangeProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("선택")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("프로필만들기텍스트필드")
        return view.endEditing(true)
    }
}


