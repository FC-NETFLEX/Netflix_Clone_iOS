//
//  PreviewCollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "PreviewCVC"
    
    private let posterImage = UIImageView()
    private let titleImage = UIImageView()
    
    private let gradient = CAGradientLayer()
    
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
        
        
        posterImage.layer.borderColor = #colorLiteral(red: 0.8588235294, green: 0, blue: 0, alpha: 1)//UIColor.setNetfilxColor(name: .netflixRed).cgColor
        posterImage.layer.borderWidth = 3
        posterImage.layer.cornerRadius = posterImageRound

        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
        
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
        
        
        posterImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(xMargin)
            $0.height.width.equalTo(imageLine)
        }
        
        titleImage.snp.makeConstraints {
            $0.centerY.equalTo(posterImage.snp.bottom)
            $0.centerX.equalTo(posterImage.snp.centerX)
            $0.height.equalTo(titleImageHeight)
            $0.width.equalTo(titleImageWidth)
            
        }
        
    }
    
    //MARK: - Gradient (그라데이션)
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradient.colors = [
            #colorLiteral(red: 0.07841768116, green: 0.07843924314, blue: 0.07841629535, alpha: 1).cgColor,
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        gradient.locations = [0,1]
        gradient.frame = CGRect(origin: .zero, size: frame.size)
        
        posterImage.layer.addSublayer(gradient)
    }
    
    //MARK: - Configure
    func configure(color: UIColor, poster: String, title: String) {
    
        self.posterImage.kf.setImage(with: URL(string: poster))
        self.titleImage.kf.setImage(with: URL(string: title))
        
    }
    
    
    
}
