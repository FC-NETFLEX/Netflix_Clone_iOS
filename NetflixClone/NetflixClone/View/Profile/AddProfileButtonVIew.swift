//
//  AddProfileButtonVIew.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol AddProfileButtonDelegate: class {
    func addProfileButtonDidTap()
}
class AddProfileButtonView: UIView {
    
    private let baseView = UIView()
    private let profilePlusButton = UIButton()
    private let addProfileLabel = UILabel()
    
    weak var delegate: AddProfileButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let cornerRadius: CGFloat = 4
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        addSubview(baseView)
        
        [profilePlusButton,addProfileLabel].forEach {
            baseView.addSubview($0)
        }
        baseView.backgroundColor = .setNetfilxColor(name: .black)
        
        profilePlusButton.setImage(UIImage(named: "플러스"), for: .normal)
        profilePlusButton.backgroundColor = #colorLiteral(red: 0.1056868053, green: 0.1067332093, blue: 0.1067332093, alpha: 1)
        profilePlusButton.layer.borderWidth = 1.6
        profilePlusButton.layer.borderColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        profilePlusButton.contentMode = .scaleAspectFill
        profilePlusButton.layer.masksToBounds = true
        profilePlusButton.layer.cornerRadius = cornerRadius
        profilePlusButton.addTarget(self, action: #selector(addProfileButtonDidTap), for: .touchUpInside)
        
        addProfileLabel.text = "프로필 추가"
        addProfileLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addProfileLabel.font = UIFont.dynamicFont(fontSize: 17, weight: .bold)
        
    }
    private func setConstrains() {
        let margin: CGFloat = 20
        let padding: CGFloat = 5
        let spacing: CGFloat = 15
        
        [baseView,profilePlusButton, addProfileLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        baseView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        baseView.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        baseView.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        
        profilePlusButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        profilePlusButton.topAnchor.constraint(equalTo: baseView.topAnchor, constant:  padding).isActive = true
        profilePlusButton.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.65).isActive = true
        profilePlusButton.heightAnchor.constraint(equalTo: profilePlusButton.widthAnchor).isActive = true
        
        addProfileLabel.topAnchor.constraint(equalTo: profilePlusButton.bottomAnchor, constant: spacing).isActive = true
        addProfileLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        addProfileLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor).isActive = true
        
        
//        profilePlusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
//        profilePlusButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        profilePlusButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
//        profilePlusButton.heightAnchor.constraint(equalTo: profilePlusButton.widthAnchor).isActive = true
//
//        addProfileLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        addProfileLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
        
    }
    @objc private func addProfileButtonDidTap() {
        delegate?.addProfileButtonDidTap()
    }
    
}
