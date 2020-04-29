//
//  SavedContentHeaderView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/17.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SavedContentHeaderView: UITableViewHeaderFooterView {
    static let identifire = "SavedContentHeaderView"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI() {
        [imageView, titleLabel].forEach({
            contentView.addSubview($0)
        })
        
        
        contentView.backgroundColor = .setNetfilxColor(name: .black)
        
        titleLabel.font = .dynamicFont(fontSize: 16, weight: .medium)
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
    }
    
    
    //MARK: Action
    
    private func setConstraint() {
        
        let yMargin = CGFloat.dynamicYMargin(margin: 8)
        let xMargin = CGFloat.dynamicXMargin(margin: 16)
//        let imageViewSize = CGFloat.dynamicYMargin(margin: 32)
        
        imageView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
//            $0.height.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(yMargin)
            $0.width.equalTo(imageView.snp.height)
//            $0.centerY.equalToSuperview()
        })
        
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(imageView.snp.trailing).offset(xMargin)
            $0.centerY.equalTo(imageView.snp.centerY)
        })
    }
    
    func configure(imageURL: URL?, title: String) {
        titleLabel.text = title
        imageView.kf.setImage(with: imageURL)
//        print(imageURL)
    }
    
    
    
}
