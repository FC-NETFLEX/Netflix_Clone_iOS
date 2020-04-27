//
//  PosterTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol PlayDelegate: class {
    func play()
}

class PosterTableViewCell: UITableViewCell {
    static let identifier = "PosterCell"
    
    weak var delegate: PlayDelegate?

    private let posterImage = UIImageView()
    private let releaseYear = UILabel()
    private let ageGroup = UIImageView()
    private let runningTime = UILabel()
    private let playButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setUI() {
        [posterImage, releaseYear, ageGroup, runningTime, playButton].forEach {
            contentView.addSubview($0)
        }
        self.backgroundColor = .clear
        
        //MARK: 요청 받아서 이미지 뿌릴 것 => Fixed
        posterImage.contentMode = .scaleToFill
        
        playButton.setTitle("▶︎ 재생", for: .normal)
        playButton.backgroundColor = UIColor.setNetfilxColor(name: .netflixRed)
        playButton.layer.cornerRadius = 3
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        //MARK: 서버에서 응답 받은 텍스트 및 이미지 => Fixed
        releaseYear.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        ageGroup.contentMode = .scaleAspectFill
        runningTime.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
    }
    
    private func setConstraints() {
        let posterImageWidth = 0.3
        let posterImageHeight = 0.5

        posterImage.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.top.equalTo(contentView.snp.top).offset(CGFloat.dynamicYMargin(margin: 70))
            $0.width.equalTo(contentView).multipliedBy(posterImageWidth)
            $0.height.equalTo(contentView).multipliedBy(posterImageHeight)
        }

        ageGroup.snp.makeConstraints {
            $0.centerX.equalTo(posterImage.snp.centerX)
            $0.top.equalTo(posterImage.snp.bottom).offset(CGFloat.dynamicYMargin(margin: 10))
            $0.width.height.equalTo(CGFloat.dynamicXMargin(margin: 24))
        }

        releaseYear.snp.makeConstraints {
            $0.centerY.equalTo(ageGroup.snp.centerY)
            $0.trailing.equalTo(ageGroup.snp.leading).offset(CGFloat.dynamicXMargin(margin: -10))
        }

        runningTime.snp.makeConstraints {
            $0.centerY.equalTo(ageGroup.snp.centerY)
            $0.leading.equalTo(ageGroup.snp.trailing).offset(CGFloat.dynamicXMargin(margin: 10))
        }

        playButton.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat.dynamicXMargin(margin: 10))
            $0.trailing.equalTo(contentView.snp.trailing).offset(CGFloat.dynamicXMargin(margin: -10))
            $0.top.equalTo(ageGroup.snp.bottom).offset(CGFloat.dynamicYMargin(margin: 30))
            $0.height.equalTo(CGFloat.dynamicYMargin(margin: 35))
            $0.bottom.equalTo(contentView.snp.bottom).inset(CGFloat.dynamicYMargin(margin: 5))
        }
    }
    
    func configure(posterImageName: String, releaseYear: String, ageGroup: String, runningTime: String) {
        self.posterImage.kf.setImage(with: URL(string: posterImageName))
        self.releaseYear.text = releaseYear
        self.ageGroup.image = UIImage(named: ageGroup)
        self.runningTime.text = runningTime
    }
    
    @objc private func didTapPlayButton() {
        delegate?.play()
    }
}
