//
//  searchResultItem.swift
//  NetflixClone
//
//  Created by MyMac on 2020/03/29.
//  Copyright © 2020 Netflex. All rights reserved.
//


import UIKit
import Kingfisher

final class ContentsBasicItem: UICollectionViewCell {
    static let identifier = "contentsBasic"
    
    private let posterImage = UIImageView()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("traitCollection cell :", frame)
    }
    
    //MARK: -UI
    private func setUI() {
        
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true

        contentView.addSubview(posterImage)
        
        posterImage.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    

    
    //MARK: -configure (포스터, contentID)
    
    func jinConfigure(urlString: String) {
        self.posterImage.kf.setImage(with: URL(string: urlString))
    }
}
