//
//  AddProfileViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/01.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

class ChangeProfileViewController: UIViewController {
    
    let addProfileView = AddProfileView()
    private let kidsCV = KidsClassView()
    private let universalCV = UniversalClassView()
    private let changeView = ChangeCustomView()
    private let deleteView = DeleteProfileButtonView()
    
    var isKids = Bool()
    var profileName = String()
    var profileIcon = UIImage()
    var profileIconNum = Int()
    var userID = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        setNavigationBar()
        isKidsViewSetting()
        
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
    private func setUI(){
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [addProfileView, changeView,universalCV,kidsCV,deleteView].forEach {
            view.addSubview($0)
        }
        addProfileView.newProfileButton.setImage(profileIcon, for: .normal)
        addProfileView.delegate = self
        addProfileView.delegate = self
        addProfileView.nickNameTextfield.delegate = self
        
        kidsCV.isHidden = true
        universalCV.isHidden = true
        
        deleteView.delegate = self
        
    }
    private func setConstraints() {
        
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 20
        let spacing: CGFloat = 80
        let inset = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        let topMargin: CGFloat = .dynamicYMargin(margin: (view.frame.height - inset) / 6)
        [addProfileView,changeView,kidsCV,universalCV,deleteView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addProfileView.topAnchor.constraint(equalTo: guide.topAnchor, constant: topMargin).isActive = true
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
    
    private func isKidsViewSetting() {
        if isKids == true {
            kidsCV.isHidden = false
            universalCV.isHidden = true
        } else {
            kidsCV.isHidden = true
            universalCV.isHidden = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        print("프로필만들기취소")
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                profileVC.root = .manager
                navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK: API
    
    
    private func profileUpdate() {
        let stringID = String(userID)
        let bodys: [String: Any] = ["profile_name": profileName, "profile_icon": profileIconNum, "is_kids": isKids]
        guard let jsonToDO = try? JSONSerialization.data(withJSONObject: bodys) else { return }
        dump(bodys)
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.makeProfile.makeURL(pathItems: [PathItem(name: stringID, value: nil)])
            else { return }
        
        print(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "PATCH"
        urlRequest.httpBody = jsonToDO
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let data = data else { return print("No Data") }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            print(jsonObject)
        }
        task.resume()
    }
    
    private func profileDelete() {
        let stringID = String(userID)
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.makeProfile.makeURL(pathItems: [PathItem(name: stringID, value: nil)])
            else { return }
        print(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let data = data else { return print("No Data") }
            print("DELETE OK!!")
            
            if let res = response as? HTTPURLResponse {
                print(res.statusCode)
            }
            if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print(jsonObject)
            }
        }
        task.resume()
    }
    
    
    @objc private func didTapSaveButton() {
        
        guard let userName = addProfileView.nickNameTextfield.text, !userName.isEmpty else { return }
        profileName = userName
        
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                profileVC.root = .main
                profileUpdate()
                navigationController?.popViewController(animated: true)
                print("프로필수정 오케이")
            }
        }
    }
}

extension ChangeProfileViewController: AddProfileViewDelegate, DeleteProfileButtonViewDelegate {
    
    func newProfileButtonDidTap() {
        print("이미지선택")
        let imageVC = ProfileImageViewController()
        imageVC.delegate = self
        imageVC.modalPresentationStyle = .overCurrentContext
        present(imageVC,animated: true)
    }
    func didTapDeleteButton() {
        for vc in navigationController!.viewControllers.reversed() {
            if let profileVC = vc as? ProfileViewController {
                profileVC.root = .main
                profileDelete()
                profileVC.userNameArray.removeAll()
                navigationController?.popViewController(animated: true)
                
                print("프로필삭제")
            }
        }
    }
}

extension ChangeProfileViewController: ProfileImageViewControllerDelegate {
    func setImage(image: UIImage, imageID: Int) {
        addProfileView.newProfileButton.setImage(image, for: .normal)
        self.profileIconNum = imageID
    }
}
extension ChangeProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addProfileView.nickNameTextfield.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
}


