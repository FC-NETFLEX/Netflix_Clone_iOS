//
//  ViewLimitView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class KidsClassView: UIView {
    
    private let kidsClassLabel = UILabel()
    private let twelveClassLabel = UILabel()
    private let viewContentsLabel = UILabel()
   
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
        
        [kidsClassLabel,twelveClassLabel,viewContentsLabel].forEach {
            self.addSubview($0)
        }
        
        kidsClassLabel.text = "키즈"
        kidsClassLabel.backgroundColor = #colorLiteral(red: 0.2531644241, green: 0.2556710025, blue: 0.2556710025, alpha: 1)
        kidsClassLabel.textAlignment = .center
        kidsClassLabel.layer.cornerRadius = 4
        kidsClassLabel.clipsToBounds = true
        kidsClassLabel.textColor = .setNetfilxColor(name: .white)
        kidsClassLabel.font = UIFont.dynamicFont(fontSize: 10, weight: .bold)
        
        twelveClassLabel.text = "12"
        twelveClassLabel.backgroundColor = #colorLiteral(red: 0.2531644241, green: 0.2556710025, blue: 0.2556710025, alpha: 1)
        twelveClassLabel.textAlignment = .center
        twelveClassLabel.layer.cornerRadius = 4
        twelveClassLabel.clipsToBounds = true
        twelveClassLabel.textColor = .setNetfilxColor(name: .white)
        twelveClassLabel.font = UIFont.dynamicFont(fontSize: 10, weight: .bold)
        
        viewContentsLabel.text = "이 프로필에서는 12등급 이하 등급의\n콘텐츠가 표시됩니다."
        viewContentsLabel.textAlignment = .center
        viewContentsLabel.numberOfLines = 0
        viewContentsLabel.textColor = .setNetfilxColor(name: .white)
        viewContentsLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular )
    }
        
    
    private func setConstraints() {
        
        let margin: CGFloat = 10
        let padding: CGFloat = 30
        
        [kidsClassLabel,twelveClassLabel,viewContentsLabel].forEach  {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        kidsClassLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        kidsClassLabel.heightAnchor.constraint(equalToConstant: padding).isActive = true
        kidsClassLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        kidsClassLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        twelveClassLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        twelveClassLabel.heightAnchor.constraint(equalToConstant: padding).isActive = true
        twelveClassLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08).isActive = true
        twelveClassLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 8).isActive = true
        
        viewContentsLabel.topAnchor.constraint(equalTo: twelveClassLabel.bottomAnchor, constant: margin * 2).isActive = true
        viewContentsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
  
    
}

