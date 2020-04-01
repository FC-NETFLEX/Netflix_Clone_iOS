//
//  searchResultItem.swift
//  NetflixClone
//
//  Created by MyMac on 2020/03/29.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
import UIKit

final class ContentsBasicItem: UICollectionViewCell {
    static let identifier = "contentsBasic"
    
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
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp.center)
        }
    }
}
