//
//  HomeviewTitle.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class HomeviewTitle: UIView {
    
    private let titlePoster = UIImageView()
    private let gradient = CAGradientLayer()
    
    private let contentView = UIView()
    private let categoryLabel = UILabel()
    private let dibsButton = UIButton()
    private let playButton = UIButton()
    private let infoButton = UIButton()
    
    private let dibsLabel = UILabel()
    private let infoLabel = UILabel()
    
    private let titleImage = UIImageView()
    
    
    //    private let gradientLayer: CAGradientLayer = {
    //        let gradientLayer = CAGradientLayer()
    //        gradientLayer.backgroundColor = UIColor.clear.cgColor
    //        gradientLayer.colors = [UIColor.black.cgColor, UIColor.gray.cgColor, UIColor.clear.cgColor]
    //        return gradientLayer
    //    }()
    
    private let gradationLayer = CAGradientLayer()
    
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
        
        let textTintColor: UIColor = .white
        let categoryFont: UIFont = .boldSystemFont(ofSize: 12)
        let fixedFont: UIFont = .systemFont(ofSize: 12)
        
        titlePoster.contentMode = .scaleAspectFill
        titlePoster.clipsToBounds = true
        
        categoryLabel.textColor = textTintColor
        categoryLabel.font = categoryFont
        
        
        dibsButton.tintColor = textTintColor
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.contentHorizontalAlignment = .center
        playButton.setTitle("   재생", for: .normal)
        playButton.titleLabel?.font = fixedFont
        playButton.setTitleColor(.black, for: .normal)
        playButton.layer.cornerRadius = 2
        playButton.tintColor = .black
        playButton.backgroundColor = textTintColor
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(didTabInfoButton(sender:)), for: .touchUpInside)
        infoButton.tintColor = textTintColor
        
        //        titleImage.contentMode = .scaleAspectFit
        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        
//        contentView.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        dibsLabel.text = "내가 찜한..."
        dibsLabel.font = fixedFont
        dibsLabel.textColor = textTintColor
        
        infoLabel.text = "정보"
        infoLabel.font = fixedFont
        infoLabel.textColor = textTintColor
        
        
        addSubview(titlePoster)
        //        titleImage.layer.addSublayer(gradientLayer)
//        titlePoster.addSubview(contentView)
//        titlePoster.addSubview(titleImage)
        addSubview(contentView)
        addSubview(titleImage)
        
        [categoryLabel, dibsButton, playButton, infoButton, dibsLabel, infoLabel].forEach {
            contentView.addSubview($0)
        }
        
        
    }
    
    
    private func setConstraints() {
        
        let xMargin: CGFloat = CGFloat.dynamicXMargin(margin: 20)
        let yMargin: CGFloat = CGFloat.dynamicYMargin(margin: 8)
        let padding: CGFloat = 8
        
        let miniButtonWidth: CGFloat = xMargin * 2
        let miniButtonHeight: CGFloat = yMargin * 4
        
        //        let titleImageWidth: CGFloat = CGFloat.dynamicXMargin(margin: 350)
        //        let titleImageHeight: CGFloat = CGFloat.dynamicYMargin(margin: 150)
        
        titlePoster.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.16)
        }
        
        titleImage.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.2)
            
        }
        
        dibsLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(yMargin)
            $0.leading.equalToSuperview().inset(xMargin + padding)
            $0.height.equalTo(miniButtonHeight)
        }
        
        infoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(yMargin)
            $0.trailing.equalToSuperview().inset(xMargin + padding * 2)
            $0.height.equalTo(miniButtonHeight)
        }
        
        dibsButton.snp.makeConstraints {
            $0.bottom.equalTo(dibsLabel.snp.top).inset(yMargin)
            $0.centerX.equalTo(dibsLabel.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWidth)
            
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).inset(yMargin)
            $0.centerX.equalTo(infoLabel.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWidth)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(titlePoster.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalToSuperview().multipliedBy(0.35)
            //            $0.width.equalTo(playButtonWith)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(playButton.snp.top).inset(-yMargin)
            $0.centerX.equalTo(titlePoster.snp.centerX)
        }
        
        
        
    }
    
    //MARK: - Gradient(그라데이션)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradient.colors = [
            #colorLiteral(red: 0.07841768116, green: 0.07843924314, blue: 0.07841629535, alpha: 1).cgColor,
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.frame = CGRect(origin: .zero, size: frame.size)
        
        titlePoster.layer.addSublayer(gradient)
    }
    
    
    
    // MARK: - configure
    func configure(poster: UIImage, category: [String], dibs: Bool, titleImage: UIImage) {
        print("HomeTitle: configure")
        
        var categoryText: String = ""
        
        category.forEach {
            categoryText += $0 + ","
        }
        
        titlePoster.image = poster
        categoryLabel.text = categoryText
        
        self.titleImage.image = titleImage
        
        if dibs {
            dibsButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            dibsButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        
        print("configure categoryText = \(categoryText)")
        
    }
    
    //MARK: - action
    @objc private func didTabdibsButton(sender: UIButton) {
        
    }
    
    @objc private func didTabPlayButton(sender: UIButton) {
        
    }
    
    @objc private func didTabInfoButton(sender: UIButton) {
        
    }
    
}
