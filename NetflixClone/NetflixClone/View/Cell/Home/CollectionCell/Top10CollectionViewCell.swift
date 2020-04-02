//
//  Top10CollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class Top10CollectionViewCell: UICollectionViewCell {
    static let identifier = "Top10CVC"
    
    private let topNumLabel = UILabel()
    private let posterImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        topNumLabel.font = .boldSystemFont(ofSize: 120)
        topNumLabel.backgroundColor = .clear
        topNumLabel.textColor = .white
        
        contentView.addSubview(posterImage)
        contentView.addSubview(topNumLabel)
    }
    private func setContraints() {
        let posterImageXmargin: CGFloat = 50
        let numberHeight: CGFloat = contentView.frame.height / 2
        
        topNumLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(numberHeight)
        }
        
        posterImage.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(posterImageXmargin)
        }
        
    }

    
    //MARK: - configure
    func configure(poster: UIImage, count: Int) {
        topNumLabel.text = "\(count + 1)"
        posterImage.image = poster
    }
}
