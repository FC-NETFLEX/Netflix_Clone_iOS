//
//  MorePofileView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol MoreProfileViewDelegate: class {
    func profileButtonDidTap(tag: Int)
    func didTapSelectButton()
}

class MorePofileView: UIView {
    
    weak var delegate: MoreProfileViewDelegate?
    let profileButton = UIButton()
    let profileLabel = UILabel()
    let selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let borderColor = UIColor.setNetfilxColor(name: .white).cgColor
        let cornerRadius: CGFloat = 4
        let borderWidth: CGFloat = 2
        
        
        backgroundColor = .setNetfilxColor(name: .black)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        [profileButton, profileLabel, selectButton].forEach {
            self.addSubview($0)
        }
        
        profileButton.setImage(UIImage(named: ""), for: .normal)
        profileButton.contentMode = .scaleAspectFill
        profileButton.imageView?.layer.masksToBounds = true
        profileButton.imageView?.layer.cornerRadius = cornerRadius
        profileButton.addTarget(self, action: #selector(profileButtonDidTap), for: .touchUpInside)
        
        profileLabel.text = ""
        profileLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        profileLabel.font = UIFont.dynamicFont(fontSize: 13, weight: .regular)
        
        
        selectButton.backgroundColor = .clear
        selectButton.layer.borderWidth = borderWidth
        selectButton.layer.cornerRadius = cornerRadius
        selectButton.layer.borderColor = borderColor
        selectButton.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        selectButton.isHidden = true

    }
    private func setConstraint() {
        
        let margin: CGFloat = 10
        let padding: CGFloat = 5
        let borderMargin: CGFloat = 2
        
        
        profileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(margin)
            $0.leading.trailing.equalToSuperview().inset(borderMargin)
            $0.height.equalTo(profileButton.snp.width)
            //            $0.bottom.equalTo(profileLabel.snp.top).offset(-30)
            
        }
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(padding)
            $0.centerX.equalTo(profileButton.snp.centerX)
        }
       
        selectButton.snp.makeConstraints {
            $0.centerY.equalTo(profileButton.snp.centerY)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(profileButton.snp.width)
            //            $0.bottom.equalTo(profileLabel.snp.top).offset(-30)
            
        }
    }
     func selectProfile() {
        profileLabel.font = UIFont.dynamicFont(fontSize: 14, weight: .bold)
        
        profileLabel.textColor = .setNetfilxColor(name: .white)
        
        selectButton.isHidden = false


    }
    @objc private func profileButtonDidTap() {
        delegate?.profileButtonDidTap(tag: self.tag)
    }
    @objc private func didTapSelectButton() {
        delegate?.didTapSelectButton()

    }
    
}


