//
//  HomeTitleContentTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

// class HomeTitleContentTableViewCell: UITableViewCell {

class HomeTitleContentCollectionViewCell: UITableViewCell {
    
    static let identifier = "HomeTitleContentCell"
    
    private let titleImage = UIImageView()
//    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dibsButton = UIButton()
    private let playButton = UIButton()
    private let infoButton = UIButton()
    
//    private let setupPlayButtonView = UIView()
    
//    private var title: String
    
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
//        self.title = title

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - UI
    
    // 재생버튼에 올라갈 뷰
//    private func setPlayButtonView() {
//        let playImage = UIImageView()
//        let playText = UILabel()
//
//        playImage.image = UIImage(systemName: "play.fill")
//        playImage.tintColor = .black
//
//        playText.text = "재생"
//        playText.textColor = .black
//
//        setupPlayButtonView.addSubview(playImage)
//        setupPlayButtonView.addSubview(playText)
//
//
//    }
    
    private func setUI() {
//        setPlayButtonView()
        
        let textTintColor: UIColor = .white
        let categoryFont: UIFont = .systemFont(ofSize: 8)
        
        
        categoryLabel.textColor = textTintColor
        categoryLabel.font = categoryFont

        
        dibsButton.tintColor = textTintColor
        
//        playButton.imageView =
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .black
        playButton.backgroundColor = textTintColor
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(didTabInfoButton(sender:)), for: .touchUpInside)
        infoButton.tintColor = textTintColor
        
       
        contentView.addSubview(titleImage)
        
        [categoryLabel, dibsButton, playButton, infoButton].forEach {
            titleImage.addSubview($0)
        }
    
        
    }
    
    private func setConstraints() {
        
        let xMargin: CGFloat = CGFloat.dynamicXMargin(margin: 16)
        let yMargin: CGFloat = CGFloat.dynamicYMargin(margin: 8)
        
        let miniButtonWith: CGFloat = xMargin
        let miniButtonHeight: CGFloat = xMargin + yMargin
        
        let playButtonWith: CGFloat = miniButtonWith * 2.5
        
        
        titleImage.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview().inset(0)
        }
        
        dibsButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(yMargin)
            $0.leading.equalToSuperview().offset(xMargin)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWith)
            
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalTo(dibsButton.snp.centerY)
            $0.centerX.equalTo(titleImage.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(playButtonWith)
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(yMargin)
            $0.trailing.equalToSuperview().offset(xMargin)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWith)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(dibsButton.snp.top).offset(yMargin)
            $0.centerX.equalTo(titleImage.snp.centerX)
        }
        
        
    }
    
    
    // MARK: - configure
    func configure(poster: UIImage, category: [String], dibs: Bool) {
        var categoryText: String = ""
        
        category.forEach {
            categoryText += $0 + ","
        }
        
        titleImage.image = poster
        categoryLabel.text = categoryText
        
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
