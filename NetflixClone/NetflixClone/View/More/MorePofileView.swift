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
}

class MorePofileView: UIView{
    
    weak var delegate: MoreProfileViewDelegate?
    let profileButton = UIButton()
    let profileLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let cornerRadius: CGFloat = 4
        backgroundColor = .setNetfilxColor(name: .black)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        [profileButton,profileLabel].forEach {
            self.addSubview($0)
        }
        
        profileButton.setImage(UIImage(named: "프로필3"), for: .normal)
        profileButton.contentMode = .scaleAspectFill
        profileButton.imageView?.layer.masksToBounds = true
        profileButton.imageView?.layer.cornerRadius = cornerRadius
        profileButton.addTarget(self, action: #selector(profileButtonDidTap), for: .touchUpInside)
        
        profileLabel.text = "양중창"
        profileLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        profileLabel.font = .systemFont(ofSize: 15)
        
    }
    
    
    private func setConstraint() {
        
        let margin: CGFloat = 10
        let padding: CGFloat = 5
  
        
        profileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(margin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(profileButton.snp.width)
//            $0.bottom.equalTo(profileLabel.snp.top).offset(-30)
           
        }
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(padding)
            $0.centerX.equalTo(profileButton.snp.centerX)

        }
            
            
    }
    @objc private func profileButtonDidTap() {
        delegate?.profileButtonDidTap(tag: self.tag)
    }
    
}


