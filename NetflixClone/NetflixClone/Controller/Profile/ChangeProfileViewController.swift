//
//  AddProfileViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/01.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


class ChangeProfileViewController: UIViewController {
    
    private let addProfileView = AddProfileView()
    private let kidsCV = KidsClassView()
    private let universalCV = UniversalClassView()
    private let changeView = ChangeCustomView()
    private let deleteView = DeleteProfileButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        setNavigationBar()
        
    }
    
    private func setNavigationBar() {
        
        navigationItem.title = "프로필 변경"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton(_:)))
        cancelButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
        saveButton.tintColor = .gray
        navigationItem.rightBarButtonItem = saveButton
        
    }
    private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [addProfileView, changeView,universalCV,kidsCV,deleteView].forEach {
            view.addSubview($0)
        }
        addProfileView.delegate = self
        addProfileView.nickNameTextfield.delegate = self
        
//        kidsCV.isHidden = true
        universalCV.isHidden = true
        
        deleteView.delegate = self
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 20
        let spacing: CGFloat = 80
        [addProfileView,changeView,kidsCV,universalCV,deleteView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addProfileView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        addProfileView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        addProfileView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        addProfileView.bottomAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        
        universalCV.topAnchor.constraint(equalTo: addProfileView.bottomAnchor, constant: margin).isActive = true
        universalCV.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        universalCV.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        universalCV.bottomAnchor.constraint(equalTo: addProfileView.bottomAnchor, constant: spacing + padding).isActive = true
        
        kidsCV.topAnchor.constraint(equalTo: addProfileView.bottomAnchor, constant: margin).isActive = true
        kidsCV.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        kidsCV.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        kidsCV.bottomAnchor.constraint(equalTo: addProfileView.bottomAnchor, constant: spacing + padding).isActive = true
        
        changeView.topAnchor.constraint(equalTo: kidsCV.bottomAnchor, constant: margin).isActive = true
        changeView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        changeView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        changeView.bottomAnchor.constraint(equalTo: kidsCV.bottomAnchor, constant: padding * 2 + margin).isActive = true
               
        deleteView.topAnchor.constraint(equalTo: changeView.bottomAnchor).isActive = true
        deleteView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        deleteView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        deleteView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc private func didTapCancelButton(_ sender: Any) {
        print("프로필만들기취소")
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                profileVC.root = .main
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func didTapSaveButton() {
        
        guard let userName = addProfileView.nickNameTextfield.text, !userName.isEmpty else { return }
        
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                profileVC.root = .main
                profileVC.userNameArray.append(userName)
                navigationController?.popViewController(animated: true)
                print("프로필만들기 오케")
            }
        }
    }
}

extension ChangeProfileViewController: AddProfileViewDelegate, DeleteProfileButtonViewDelegate {
  
    func newProfileButtonDidTap() {
        print("이미지선택")
        let imageVC = ProfileImageViewController()
        imageVC.modalPresentationStyle = .overCurrentContext
        present(imageVC,animated: true)
    }
    func didTapDeleteButton() {
        guard let userName = addProfileView.nickNameTextfield.text, !userName.isEmpty else { return }
               
        for vc in navigationController!.viewControllers.reversed() {
        if let profileVC = vc as? ProfileViewController {
            profileVC.root = .main
            profileVC.userNameArray.removeAll()
            navigationController?.popViewController(animated: true)
        
        print("프로필삭제")
            }
        }
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


