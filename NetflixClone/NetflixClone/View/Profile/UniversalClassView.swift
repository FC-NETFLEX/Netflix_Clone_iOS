//
//  UniversalClassView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class UniversalClassView: UIView {
    
    private let viewtingClassLabel = UILabel()
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
        
        [viewtingClassLabel,viewContentsLabel].forEach {
            self.addSubview($0)
        }
        
        viewtingClassLabel.text = "모든 관람등급"
        viewtingClassLabel.backgroundColor = #colorLiteral(red: 0.2531644241, green: 0.2556710025, blue: 0.2556710025, alpha: 1)
        viewtingClassLabel.textAlignment = .center
        viewtingClassLabel.layer.cornerRadius = 4
        viewtingClassLabel.clipsToBounds = true
        viewtingClassLabel.textColor = .setNetfilxColor(name: .white)
        viewtingClassLabel.font = UIFont.dynamicFont(fontSize: 10, weight: .bold)
        
        viewContentsLabel.text = "이 프로필에서는 모든 관람등급 등급의\n콘텐츠가 표시됩니다."
        viewContentsLabel.textAlignment = .center
        viewContentsLabel.numberOfLines = 0
        viewContentsLabel.textColor = .setNetfilxColor(name: .white)
        viewContentsLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular)
        
    }
    private func setConstraints() {
        
        let margin: CGFloat = 10
        let padding: CGFloat = 30
        
        [viewtingClassLabel,viewContentsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        viewtingClassLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        viewtingClassLabel.heightAnchor.constraint(equalToConstant: padding).isActive = true
        viewtingClassLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
        viewtingClassLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        viewContentsLabel.topAnchor.constraint(equalTo: viewtingClassLabel.bottomAnchor, constant: margin * 2).isActive = true
        viewContentsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
        
}
