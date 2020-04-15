//
//  RecommendedContentsCollectionViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/03.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

// MARK: 비슷한 콘텐츠 collectionView Item
class RecommendedCollectionViewItem: UICollectionViewCell {
    static let identifier = "RecommendedCollectionViewCell"
    
    let posterImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUI()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
        
        contentView.addSubview(posterImage)
    }
    
    private func setContraints() {
        posterImage.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalTo(self)
        }
        
    }
    
    //MARK: - configure
    func configure(poster: String) {
        posterImage.kf.setImage(with: URL(string: poster))
    }
}
