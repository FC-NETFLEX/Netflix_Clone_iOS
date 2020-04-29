//
//  ProfileManageButton.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileManageButtonDelegate: class {
    func didTapMoreProfileButton()
}

class ProfileManageButton: UIView {
    var delegate: ProfileManageButtonDelegate?
    
    private let moreProfileButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [moreProfileButton].forEach {
            addSubview($0)
        }
        moreProfileButton.setImage(UIImage(named: "더보기펜슬"), for: .normal)
        moreProfileButton.setTitle("   프로필 관리", for: .normal)
        moreProfileButton.setTitleColor(UIColor.setNetfilxColor(name: .netflixLightGray), for: .normal)
        moreProfileButton.addTarget(self, action: #selector(didTapMoreProfileButton), for: .touchUpInside)
        moreProfileButton.contentMode = .scaleAspectFill
        moreProfileButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 14, weight: .bold)
        
        
        
        
    }
    private func setConstraints() {
        
        moreProfileButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            
        }
    }
    
    @objc private func didTapMoreProfileButton() {
        delegate?.didTapMoreProfileButton()
        
    }
}
