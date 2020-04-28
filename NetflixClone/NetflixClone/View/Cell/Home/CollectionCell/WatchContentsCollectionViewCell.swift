//
//  WatchContentsCollectionViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/04.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

protocol WatchContentsCollectionViewCellDelegate: class {
    func didTapWatchContentInfo(contentId: Int) -> ()
    func didTapWatchPlay(contentID: Int) -> ()
}

class WatchContentsCollectionViewCell: UICollectionViewCell {
    static let identifier = "WatchContentCVC"
    
    weak var delegate: WatchContentsCollectionViewCellDelegate?
    
    private let posterButton = UIButton()//UIImageView()
    //    private let posterImage = UIImageView()

    private let progressView = UIProgressView()
    
    private let infoView = UIView()
    private let watchTimeLabel = UILabel()
    private let infoButton = UIButton()//UIImageView()
    
    private let playButton = UIButton()//UIImageView()
    
//    private var id: Int?
    private var contentId: Int?
    
    
    //MARK: initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
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
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.netflixLightGray)
        infoButton.addTarget(self, action: #selector(didTapInfoButton(sender:)), for: .touchUpInside)
        
        playButton.setImage(UIImage(named: "playIcon"), for: .normal)
        playButton.contentMode = .scaleAspectFill
        playButton.backgroundColor = .clear
        playButton.layer.cornerRadius = 40// playView.frame.width / 2
        playButton.clipsToBounds = true
        playButton.addTarget(self, action: #selector(didTapPlay(sender:)), for: .touchUpInside)
        
        posterButton.addTarget(self, action: #selector(didTapPlay(sender:)), for: .touchUpInside)
        posterButton.backgroundColor = .clear
        posterButton.layer.masksToBounds = true
        posterButton.imageView?.contentMode = .scaleToFill
        
        
        watchTimeLabel.font = timeLabelFont
        watchTimeLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.netflixLightGray)//.lightGray
        
        contentView.addSubview(posterButton)
        contentView.addSubview(progressView)
        contentView.addSubview(infoView)
        posterButton.addSubview(playButton)
        infoView.addSubview(watchTimeLabel)
        infoView.addSubview(infoButton)
    }
    
    private func setConstraints() {
        
        let posterHeight: CGFloat = round(contentView.frame.height / 4) * 3
        let playViewSize: CGFloat = round(contentView.frame.width / 1.5)
        let margin: CGFloat = 5
        let infoImageSize: CGFloat = 20
        let progressHeight: CGFloat = 5
        
       
        posterButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(posterHeight)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(posterButton.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(progressHeight)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.centerX.equalTo(posterButton.snp.centerX)
            $0.centerY.equalTo(posterButton.snp.centerY)
            $0.height.width.equalTo(playViewSize)
        }
        
        infoButton.snp.makeConstraints {
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
    func configure(/*id: Int*,*/contentId: Int, poster: URL, watchTime: String, playMark: Double) {
//        self.id = id
        self.contentId = contentId
        watchTimeLabel.text = watchTime

        progressView.setProgress(Float(playMark), animated: true)   // 길이

        KingfisherManager.shared.retrieveImage(with: poster, completionHandler: {
            result in
            switch result {
            case .success(let imageResult):
                self.posterButton.setBackgroundImage(imageResult.image, for: .normal)
            case .failure(let error):
                print(error)
            }
        })
        
        
    }
    
    
    @objc private func didTapInfoButton(sender: UIButton) {
        delegate?.didTapWatchContentInfo(contentId: contentId!)
    }
    
    @objc private func didTapPlay(sender: UIButton) {
        delegate?.didTapWatchPlay(contentID: contentId!)
    }
}
