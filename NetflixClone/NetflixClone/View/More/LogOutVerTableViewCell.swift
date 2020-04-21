//
//  LogOutVerTableViewCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class LogOutVerTableViewCell: UITableViewCell {
    static let identifier = "LogOutVerTableViewCell"
    
    private let logoutLabel = UILabel()
    private let versionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [logoutLabel,versionLabel].forEach {
            addSubview($0)
        }
        logoutLabel.text = "로그아웃"
        logoutLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        logoutLabel.textAlignment = .center
        logoutLabel.font = UIFont.systemFont(ofSize: 17)
        
        versionLabel.text = "버전: 92.09.18(1234)"
        versionLabel.textColor = .setNetfilxColor(name: .netflixDarkGray)
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func setConstraints() {
        let margin: CGFloat = 10
        
        
        logoutLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(snp.centerY)
        }
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoutLabel.snp.bottom).inset(-margin)
        }
        
    }
    
    
}

