//
//  ChangeProfileViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ChangeProfileViewController: UIViewController {
    
   private let addProfileView = AddProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        
    }
   private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        [addProfileView].forEach {
            view.addSubview($0)
        }
        addProfileView.delegate = self
        
    }
   private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        let padding: CGFloat = 20
        [addProfileView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addProfileView.topAnchor.constraint(equalTo: guide.topAnchor, constant: padding * 2).isActive = true
        addProfileView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding).isActive = true
        addProfileView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding).isActive = true
        addProfileView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding * 2).isActive = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}
extension ChangeProfileViewController: AddProfileViewDelegate {
    func kidsSwitchDidTap() {
        func alertAction() {
            let alert =  UIAlertController(title: nil, message: "본 프로필의 연령 제한이 풀려 이제 모든 등급의 영화와 TV 프로그램을 시청할 수 있게 됩니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
            }
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    func newProfileButtonDidTap() {
        print("이미지선택")
        let ProfileImageVC = ProfileImageViewController()
        ProfileImageVC.modalPresentationStyle = .fullScreen
        present(ProfileImageVC, animated: true)
    }
}
