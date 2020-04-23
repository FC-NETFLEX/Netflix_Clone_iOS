//
//  FindStorableContentTableViewCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class FindStorableContentTableViewCell: UITableViewCell {
    
    static let identifier = "FindStorableContentTableViewCell"
    
    private let categoryLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .black)
        
        contentView.addSubview(categoryLabel)
        
        categoryLabel.textColor = .setNetfilxColor(name: .white)
        
        
    }
    
    private func setConstraint() {
        
        let topInset = CGFloat.dynamicYMargin(margin: 16)
        let leftInset = CGFloat.dynamicXMargin(margin: 8)
        
        categoryLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(topInset)
            $0.leading.equalToSuperview().offset(leftInset)
        })
    }
    
    func configure(categoryName: String?) {
        categoryLabel.text = categoryName
    }
    
}
