//
//  ProfileManageTopView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/31.
//  Copyright © 2020 Netflex. All rights reserved.
//



import UIKit

protocol ProfileManageTopViewDelegate: class {
    func didTapCompleteButton()
}

class ProfileManageTopView: UIView {
    
    let titleLabel = UILabel()
    let completeButton = UIButton()
    
    weak var delegate: ProfileManageTopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        [titleLabel,completeButton].forEach {
            addSubview($0)
            
            titleLabel.text = "프로필 관리"
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.dynamicFont(fontSize: 17, weight: .regular)
            titleLabel.textColor = .setNetfilxColor(name: .white)
            titleLabel.backgroundColor = .setNetfilxColor(name: .black)
            
            completeButton.setTitle("완료", for: .normal)
            completeButton.titleLabel?.textColor = .setNetfilxColor(name: .white)
            completeButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 14, weight: .heavy)
            completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
            completeButton.backgroundColor = .setNetfilxColor(name: .black)
            
            
        }
        
    }
    func setConstraints() {
        [titleLabel,completeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
            
            completeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            completeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
        }
        
    }
    @objc private func didTapCompleteButton() {
        delegate?.didTapCompleteButton()
        
        
    }
}

