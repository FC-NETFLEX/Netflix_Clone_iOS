//
//  MoreAddProfileButtonView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//
import UIKit
import SnapKit

protocol MoreAddProfileButtonViewDelegate: class {
    func addProfileButtonDidTap()
}
class MoreAddProfileButtonView: UIView {
    
    private let profilePluButton = UIButton()
    private let addProfileLabel = UILabel()
    private let selectButton = UIButton()
    
    weak var delegate: MoreAddProfileButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        let cornerRadius: CGFloat = 4
        backgroundColor = .setNetfilxColor(name: .black)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        [profilePluButton, addProfileLabel].forEach {
            self.addSubview($0)
        }
        profilePluButton.setImage(UIImage(named: "더보기플러스"), for: .normal)
        profilePluButton.backgroundColor = .setNetfilxColor(name: .black)
        profilePluButton.layer.borderWidth = 1.5
        profilePluButton.layer.borderColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        profilePluButton.contentMode = .scaleAspectFill
        profilePluButton.layer.masksToBounds = true
        profilePluButton.layer.cornerRadius = cornerRadius
        profilePluButton.addTarget(self, action: #selector(addProfileButtonDidTap), for: .touchUpInside)
        
        addProfileLabel.text = "프로필 추가"
        addProfileLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        addProfileLabel.font = UIFont.dynamicFont(fontSize: 13, weight: .regular)
    }
    private func setConstrains() {
        let padding: CGFloat = 10
        
        
        profilePluButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(padding)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.75)
            $0.height.equalTo(profilePluButton.snp.width)
        }
        addProfileLabel.snp.makeConstraints {
            $0.top.equalTo(profilePluButton.snp.bottom).offset(padding)
            $0.centerX.equalTo(profilePluButton.snp.centerX)
        }
    }
    
    @objc private func addProfileButtonDidTap() {
        delegate?.addProfileButtonDidTap()
    }
    
}
