//
//  ProfileView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol ProfilViewDelegate: class {
    func profileButtonDidTap()
    func profileChangeButtonDidTap(blurView: UIView, pencilButton: UIButton)
}

class ProfileView: UIView {
    
    private let profileButton = UIButton()
    let profileLabel = UILabel()
    private let pencilButton = UIButton()
    private let blurView = UIView()
    
    weak var delegate: ProfilViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
        setHidden(state: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let cornerRadius: CGFloat = 4
        backgroundColor = .setNetfilxColor(name: .black)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        [profileButton,profileLabel,blurView,pencilButton].forEach {
            self.addSubview($0)
        }
        
        profileButton.setImage(UIImage(named: "프로필2"), for: .normal)
        profileButton.contentMode = .scaleAspectFill
        profileButton.imageView?.layer.masksToBounds = true
        profileButton.imageView?.layer.cornerRadius = cornerRadius
        profileButton.addTarget(self, action: #selector(profileButtonDidTap), for: .touchUpInside)
        
        profileLabel.text = "양중창"
        profileLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        profileLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        pencilButton.setImage(UIImage(named: "펜슬"), for: .normal)
        pencilButton.contentMode = .scaleAspectFit
        pencilButton.addTarget(self, action: #selector(profileChangeButtonDidTap), for: .touchUpInside)
        
    }
    
    func setHidden(state: Bool) {
        blurView.isHidden = state
        pencilButton.isHidden = state
    }
    
    private func setConstraint() {
        
        let margin: CGFloat = 15
        let padding: CGFloat = 10
        
        [profileButton,profileLabel,blurView,pencilButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            profileButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            profileButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
            profileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
            profileButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
            profileButton.widthAnchor.constraint(equalTo: profileButton.heightAnchor).isActive = true
            
            profileLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: padding / 2).isActive = true
            profileLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            blurView.topAnchor.constraint(equalTo: profileButton.topAnchor).isActive = true
            blurView.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor).isActive = true
            blurView.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor).isActive = true
            blurView.bottomAnchor.constraint(equalTo:  profileButton.bottomAnchor).isActive = true
            
            pencilButton.topAnchor.constraint(equalTo: profileButton.topAnchor).isActive = true
            pencilButton.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor).isActive = true
            pencilButton.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor).isActive = true
            pencilButton.bottomAnchor.constraint(equalTo:  profileButton.bottomAnchor).isActive = true
            
        }
    }
    @objc private func profileButtonDidTap() {
        delegate?.profileButtonDidTap()
    }
    @objc private func profileChangeButtonDidTap() {
        delegate?.profileChangeButtonDidTap(blurView: blurView, pencilButton: pencilButton)
    }
}

