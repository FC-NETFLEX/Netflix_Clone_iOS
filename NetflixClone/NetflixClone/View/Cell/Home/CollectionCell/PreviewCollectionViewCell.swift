//
//  PreviewCollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "PreviewCVCell"
    
    private let posterImage = UIImageView()
    private let titleImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -UI
    private func setUI() {
        let posterImageRound: CGFloat = contentView.frame.width / 2
        
        
        posterImage.layer.borderColor = UIColor.setNetfilxColor(name: .netflixRed).cgColor
        posterImage.layer.borderWidth = 3
        posterImage.layer.cornerRadius = posterImageRound
        posterImage.layer.masksToBounds = true
        
        posterImage.contentMode = .scaleAspectFill
        
        titleImage.contentMode = .scaleAspectFit
        
        contentView.addSubview(posterImage)
        
        contentView.addSubview(titleImage)
    }
    
    private func setConstraints() {
        let yMargin: CGFloat = .dynamicYMargin(margin: 4)
        let xMargin: CGFloat = .dynamicXMargin(margin: 4)
        let padding: CGFloat = 2
        
        let imageLine: CGFloat = contentView.frame.width
        
        let titleImageWidth: CGFloat = imageLine - padding
        let titleImageHeight: CGFloat = contentView.frame.height / 6 * 2
        
        print("PreviewCollectionViewCell: cotnetView = \(contentView.frame) imageLine = \(imageLine), titleImageHeight = \(titleImageHeight)")
        

        
        posterImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(xMargin)
            $0.height.width.equalTo(imageLine)
        }
        
        titleImage.snp.makeConstraints {
            $0.centerY.equalTo(posterImage.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(titleImageHeight)
            $0.width.equalTo(titleImageWidth)
            
        }
        
    }
    
    //MARK: - Configure
    func configure(color: UIColor, poster: UIImage, title: UIImage) {
        self.posterImage.image = poster
        self.titleImage.image = title
    }
    
}
