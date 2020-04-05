//
//  WatchContentsCollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/04.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class WatchContentsCollectionViewCell: UICollectionViewCell {
    static let identifier = "WatchContentCVC"
    
    private let posterImage = UIImageView()
    private let progressView = UIProgressView()
    
    private let infoView = UIView()
    private let watchTimeLabel = UILabel()
    private let infoImage = UIImageView()
    
    private let playView = UIImageView()
    
    
    //MARK: initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MAKR: UI
    private func setUI() {
        let timeLabelFont: UIFont = .systemFont(ofSize: 14)
        
        progressView.tintColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.netflixRed)//.red
        progressView.trackTintColor = .darkGray
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        progressView.progress = 0.0
        
        infoView.backgroundColor = .black
        
        infoImage.image = UIImage(systemName: "info.circle")
        infoImage.tintColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.netflixLightGray)
        
        playView.image = UIImage(named: "playIcon")//UIImage(systemName: "play.fill")
        playView.contentMode = .scaleAspectFill
        playView.backgroundColor = .clear
        playView.layer.cornerRadius = 40// playView.frame.width / 2
        playView.clipsToBounds = true
        
        watchTimeLabel.font = timeLabelFont
        watchTimeLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.netflixLightGray)//.lightGray
        
        contentView.addSubview(posterImage)
        contentView.addSubview(progressView)
        contentView.addSubview(infoView)
        posterImage.addSubview(playView)
        infoView.addSubview(watchTimeLabel)
        infoView.addSubview(infoImage)
    }
    
    private func setConstraints() {
        
        let posterHeight: CGFloat = round(contentView.frame.height / 4) * 3
        let playViewSize: CGFloat = round(contentView.frame.width / 1.5)
        let margin: CGFloat = 5
        let infoImageSize: CGFloat = 20
        let progressHeight: CGFloat = 5
        
       
        posterImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(posterHeight)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(progressHeight)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        playView.snp.makeConstraints {
            $0.centerX.equalTo(posterImage.snp.centerX)
            $0.centerY.equalTo(posterImage.snp.centerY)
            $0.height.width.equalTo(playViewSize)
        }
        
        infoImage.snp.makeConstraints {
            $0.centerY.equalTo(infoView.snp.centerY)
            $0.trailing.equalToSuperview().inset(margin)
            $0.width.height.equalTo(infoImageSize)
        }
        
        watchTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoView.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(margin)
        }
        
        
    }
    
    //MARK: configure
    func configure(poster: UIImage, watchTime: String, playMark: Double) {
        posterImage.image = poster
        watchTimeLabel.text = watchTime

        progressView.setProgress(Float(playMark), animated: true)   // 길이
    }
}
