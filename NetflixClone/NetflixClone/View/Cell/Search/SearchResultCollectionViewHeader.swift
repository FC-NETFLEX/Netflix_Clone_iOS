//
//  SearchResultCollectionViewHeader.swift
//  NetflixClone
//
//  Created by MyMac on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class SearchResultCollectionViewHeader: UICollectionReusableView {
    static let identifier = "sectionHeaderView"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.setNetfilxColor(name: .netflixDarkGray)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        titleLabel.font = UIFont.dynamicFont(fontSize: 13, weight: .bold)
        titleLabel.text = "영화 및 TV 프로그램"
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(10)
        }
    }
}
