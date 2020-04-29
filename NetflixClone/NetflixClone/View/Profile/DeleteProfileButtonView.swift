//
//  DeleteProfileButtonView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol DeleteProfileButtonViewDelegate: class {
    func didTapDeleteButton()
}

class DeleteProfileButtonView: UIView {
    
    private let deleteButton = UIButton()
    
    weak var delegate: DeleteProfileButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [deleteButton].forEach {
            self.addSubview($0)
        }
        
        deleteButton.setImage(UIImage(named: "프로필삭제"), for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        deleteButton.contentMode = .scaleAspectFill
        deleteButton.backgroundColor = .setNetfilxColor(name: .black)
        deleteButton.setTitle(" 삭제", for: .normal)
        deleteButton.tintColor = .setNetfilxColor(name: .white)
        deleteButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 13, weight: .bold)
        
        
        
    }
    func setConstraints() {
        let margin: CGFloat = 10
        
        [deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(greaterThanOrEqualToConstant: margin / 2).isActive = true

        
    }
    @objc private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
    }
}
