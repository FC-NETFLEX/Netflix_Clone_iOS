//
//  AccountView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class AccountView: UIView {
    
    private let accountImage = UIImageView()
    private let accountLabel = UILabel()
    private let accountManageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .black)
        
        [accountImage, accountLabel, accountManageLabel].forEach {
            addSubview($0)
        }
        
        accountImage.image = UIImage(named: "계정탭")
        accountImage.contentMode = .scaleAspectFill
        
        accountLabel.text = "계정 설정을 찾으세요?"
        accountLabel.textColor = .setNetfilxColor(name: .white)
        accountLabel.font = UIFont.dynamicFont(fontSize: 18, weight: .bold)
        accountLabel.textAlignment = .center
        
        accountManageLabel.text = "계정 관리는 넷플릭스 웹사이트로 이동해\n진행하세요."
        accountManageLabel.numberOfLines = 0
        accountManageLabel.textColor = .setNetfilxColor(name: .white)
        accountManageLabel.font = UIFont.dynamicFont(fontSize: 16, weight: .light)
        accountManageLabel.textAlignment = .center
        
        
        
        
        
    }
    private func setConstraints() {
        let padding: CGFloat = 30
        
        accountImage.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo(snp.width).multipliedBy(0.5)
            $0.height.equalTo(accountImage.snp.width)
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(accountImage.snp.bottom).inset(-padding)
            $0.centerX.equalToSuperview()
            
        }
        accountManageLabel.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).inset(-padding / 2)
            $0.centerX.equalToSuperview()
        }
        
        
        
    }
    
}
