//
//  AddProfileButtonVIew.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol AddProfileButtonDelegate: class {
    func addProfileButtonDidTap()
}
class AddProfileButtonView: UIView {
    
    private let profilePluButton = UIButton()
    private let addProfileLabel = UILabel()
    
    weak var delegate: AddProfileButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        let cornerRadius: CGFloat = 8
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        [profilePluButton,addProfileLabel].forEach {
            self.addSubview($0)
        }
        profilePluButton.setImage(UIImage(named: "플러스"), for: .normal)
        profilePluButton.backgroundColor = #colorLiteral(red: 0.09802349657, green: 0.0980482474, blue: 0.09802193195, alpha: 1)
        profilePluButton.layer.borderWidth = 1.5
        profilePluButton.layer.borderColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        profilePluButton.contentMode = .scaleAspectFill
        profilePluButton.layer.masksToBounds = true
        profilePluButton.layer.cornerRadius = cornerRadius
        profilePluButton.addTarget(self, action: #selector(addProfileButtonDidTap), for: .touchUpInside)
        
        addProfileLabel.text = "프로필 추가"
        addProfileLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addProfileLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
    }
    private func setConstrains() {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
        
        [profilePluButton, addProfileLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profilePluButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
        profilePluButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profilePluButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55).isActive = true
        profilePluButton.heightAnchor.constraint(equalTo: profilePluButton.widthAnchor).isActive = true

        addProfileLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addProfileLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    @objc private func addProfileButtonDidTap() {
        delegate?.addProfileButtonDidTap()
    }
    
}
