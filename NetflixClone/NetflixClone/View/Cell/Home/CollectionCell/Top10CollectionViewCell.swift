//
//  Top10CollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

class Top10CollectionViewCell: UICollectionViewCell {
    static let identifier = "Top10CVC"
    
    private let topNumImage = UIImageView()


    private let posterImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
        
        topNumImage.backgroundColor = .clear
        topNumImage.contentMode = .scaleAspectFill
        
        contentView.addSubview(posterImage)
        contentView.addSubview(topNumImage)
    }
    private func setConstraints() {
        let posterImageXmargin: CGFloat = 40
        let numberHeight: CGFloat = contentView.frame.height / 2
        let numberWitdh: CGFloat = numberHeight + 10
        
        topNumImage.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(numberHeight)
            $0.width.equalTo(numberHeight)
        }
        
        posterImage.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(posterImageXmargin)
        }
        
    }

    
    //MARK: - configure
    func configure(poster: String, count: Int) {
        
        topNumImage.image = UIImage(named: "\(count + 1)")
        posterImage.kf.setImage(with: URL(string: poster))
        
    }
}
