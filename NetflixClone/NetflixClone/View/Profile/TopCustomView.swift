//
//  TopCustomView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
protocol TopCustomViewDelegate: class {
    func didTapBackButton()
}

class TopCustomView: UIView {
    let titleLabel = UILabel()
    let backButton = UIButton()
    
    weak var delegate: TopCustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        [titleLabel,backButton].forEach {
            addSubview($0)
            
            titleLabel.text = "아이콘 선택"
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.dynamicFont(fontSize: 17, weight: .regular)
            titleLabel.textColor = .setNetfilxColor(name: .white)
            titleLabel.backgroundColor = .setNetfilxColor(name: .black)
  
            backButton.setImage(UIImage(named: "백"), for: .normal)
            backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
            backButton.contentMode = .scaleAspectFill
            backButton.backgroundColor = .setNetfilxColor(name: .black)

            
        }
        
    }
    func setConstraints() {
        [titleLabel,backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
            
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
        }
        
    }
    @objc private func didTapBackButton() {
        delegate?.didTapBackButton()
        
        
    }
}

