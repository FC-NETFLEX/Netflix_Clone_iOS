//
//  searchResultItem.swift
//  NetflixClone
//
//  Created by MyMac on 2020/03/29.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
import UIKit

final class SearchResultItem: UICollectionViewCell {
    static let identifier = "searchResultItem"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.setNetfilxColor(name: .black)
        titleLabel.font = UIFont.dynamicFont(fontSize: 15, weight: .bold)
        titleLabel.text = "영화 및 TV 프로그램"
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp.center)
            
        }
    }
}
