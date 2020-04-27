//
//  ChangeCustomView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/01.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ChangeCustomView: UIView {
    
    private let watchLimitLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        [watchLimitLabel].forEach {
            self.addSubview($0)
        }
        
        watchLimitLabel.text = "시청 제한 설정은 웹사이트의 계정 설정에서\n변경하실 수 있습니다."
        watchLimitLabel.textAlignment = .center
        watchLimitLabel.numberOfLines = 0
        watchLimitLabel.textColor = #colorLiteral(red: 0.2531644241, green: 0.2556710025, blue: 0.2556710025, alpha: 1)
        watchLimitLabel.font = UIFont.dynamicFont(fontSize: 11, weight: .regular)
        
        
    }
    private func setConstraints() {
        
        [watchLimitLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        watchLimitLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        watchLimitLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
}


