//
//  SavedContentCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SavedContentCell: UITableViewCell {
    
    static let identifier = "SavedContentCell"
    
    
    private let thumbnailView = UIButton()
    private let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
    private let playImageBackgroundView = CircleView()
    private let summaryLabel = UILabel()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusView = SaveContentStatusView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraint()
//        test()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .black)
        [summaryLabel, thumbnailView, titleLabel, descriptionLabel, statusView].forEach({
            contentView.addSubview($0)
        })
        
//        let sizeGuide = UIScreen.main.bounds.height / 7
        
        selectionStyle = .none
        
        thumbnailView.addSubview(playImageBackgroundView)
        playImageBackgroundView.addSubview(playImageView)
        
        thumbnailView.contentMode = .scaleAspectFill
        
        playImageView.contentMode = .scaleAspectFit
        playImageView.tintColor = .setNetfilxColor(name: .white)
        
        thumbnailView.backgroundColor = .blue
        
        playImageBackgroundView.layer.borderColor = UIColor.setNetfilxColor(name: .white).cgColor
        playImageBackgroundView.layer.borderWidth = 1
        playImageBackgroundView.backgroundColor = UIColor.setNetfilxColor(name: .black).withAlphaComponent(0.3)
        
        
        let titleFontSize: CGFloat = 20
        titleLabel.font = .dynamicFont(fontSize: titleFontSize, weight: .heavy)
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        descriptionLabel.font = .dynamicFont(fontSize: titleFontSize * 0.7, weight: .light)
        descriptionLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        
        summaryLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        summaryLabel.font = .dynamicFont(fontSize: titleFontSize * 0.8, weight: .regular)
        summaryLabel.numberOfLines = 0
        
        
        
    }
    
    private func setConstraint() {
        let xMargin = CGFloat.dynamicXMargin(margin: 16)
        let yMargin = CGFloat.dynamicYMargin(margin: 8)
        
        let xPading = CGFloat.dynamicXMargin(margin: 8)
        
        
        thumbnailView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
            $0.top.equalToSuperview().offset(yMargin)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(0.6)
        })
        
        playImageBackgroundView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailView.snp.height).multipliedBy(0.5)
        })
        
        playImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(playImageBackgroundView.snp.height).multipliedBy(0.5)
        })
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.bottom.equalTo(thumbnailView.snp.centerY)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.top.equalTo(thumbnailView.snp.centerY)
        })
        
        statusView.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-xMargin)
            $0.centerY.equalTo(thumbnailView)
            $0.height.width.equalTo(thumbnailView.snp.height).multipliedBy(0.5)
        })
        
        summaryLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(xMargin)
            $0.top.equalTo(thumbnailView.snp.bottom)
            $0.bottom.equalToSuperview()
        })
        
    }
    
    
    private func setImage(stringURL: String) {
        
    }
    
    func configure(title: String, description: String, stringImageURL: String, summary: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        setImage(stringURL: stringImageURL)
        summaryLabel.text = summary
    }
    
    func insertSummary(summary: String) {
        summaryLabel.text = summary
    }
    
        
}


