//
//  LogOutVerTableViewCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol LogOutVerViewDelegate: class {
    func didTapLogoutButton()
}

class LogOutVerView: UIView{
    
    weak var delegate: LogOutVerViewDelegate?
   
    private let logoutButton = UIButton()
    private let versionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [logoutButton,versionLabel].forEach {
            addSubview($0)
        }
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(UIColor.setNetfilxColor(name: .netflixLightGray), for: .normal)
        logoutButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 15, weight: .regular)
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        versionLabel.text = "버전: 92.09.18(1234)"
        versionLabel.textColor = .setNetfilxColor(name: .netflixDarkGray)
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.dynamicFont(fontSize: 15, weight: .regular)
    }
    
    private func setConstraints() {
        let margin: CGFloat = 10
        
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
        }
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoutButton.snp.bottom).inset(-margin)
        }
        
    }
    @objc func didTapLogoutButton() {
        delegate?.didTapLogoutButton()
    }
    
    
}

