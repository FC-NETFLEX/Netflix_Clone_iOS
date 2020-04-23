//
//  VideoAdvertisementTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/05.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import AVKit

protocol VideoAdvertisementTableViewCellDelegate: class {
    func didTabVideoView(contentId: Int) -> ()
    func didTabVideoCellPlayButton() -> ()
    func didTabVideoCellDibsButton() -> ()
}

class VideoAdvertisementTableViewCell: UITableViewCell {
    
    static let identifier = "VideoAdvertisementTC"
    
    weak var delegate: VideoAdvertisementTableViewCellDelegate?
    
    private let headerHeight: CGFloat = 24
    
    private let headerLabel = UILabel()
    private let playButton = UIButton()
    private let dibsButton = UIButton()
    
    private let videoView = UIView()
    private let muteButton = UIButton()
    
    private var muteFlag = true
    
    private var contentID: Int?
    
    //    private var url: URL?
    var player: AVPlayer?
    
    func setPlayer(url: URL?) {
        guard let url = url else { return }
        player = AVPlayer(url: url)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, url: URL?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        
        
        setPlayer(url: url)
        setUI()
        setConstrinats()
        
    
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -UI
    private func setUI() {
        let HeaderFont: UIFont = .boldSystemFont(ofSize: 16)
        headerLabel.font = HeaderFont
        headerLabel.backgroundColor = .clear
        headerLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        
        
        videoView.backgroundColor = .black
//        videoView.backgroundColor = UIColor(patternImage: UIImage(named: "NETFLIX_Video")!)
        
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 5
        playButton.setTitle("재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        //        playButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        playButton.addTarget(self, action: #selector(didTabPlayButton(sender:)), for: .touchUpInside)
        
        dibsButton.backgroundColor = .gray
        dibsButton.layer.cornerRadius = 5
        dibsButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        dibsButton.setTitleColor(.white, for: .normal)
        //        dibsButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        dibsButton.addTarget(self, action: #selector(didTabDibsButton(sender:)), for: .touchUpInside)
        
        muteButton.backgroundColor = .clear
        muteButton.setImage(UIImage(named: "Mute_icon"), for: .normal)
        muteButton.addTarget(self, action: #selector(didTabMuteButton(sender:)), for: .touchUpInside)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(dibsButton)
        contentView.addSubview(videoView)
        
        
    }
    
    //MARK: -layoutSubviews
    //layer 위에 음소거 버튼 넣어야 영상위에 셋팅

    override func layoutSubviews() {
        super.layoutSubviews()
        //MARK: -Video
        //        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        //        playerLayer.frame = videoView.frame
        
        videoView.layer.addSublayer(playerLayer)
        
        print("\n*********************\n\nVideoView",player?.status.rawValue)
//MARK: - 음소거버튼 셋팅
        videoView.addSubview(muteButton)
        
        let muteButtonSize: CGFloat = 20
        
        muteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(muteButtonSize)
        }
        
        
        
        player?.play()
        player?.isMuted = true
    }
    
    
    
    private func setConstrinats() {
        let headerYMargin: CGFloat = 10
        let headerXMargin: CGFloat = 10
        
        let margin: CGFloat = 10
        
//        let muteButtonSize: CGFloat = 20
        
        let buttonHeight: CGFloat = 25
        let buttonWidth: CGFloat = round(contentView.frame.width - (margin * 3) ) / 2
        
        let viewHeight: CGFloat = round(contentView.frame.height / 3 ) * 2
        
        
    
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(headerYMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerHeight - headerYMargin)
        }
        
        videoView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(buttonHeight + margin * 2)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(videoView.snp.bottom).offset(margin)
            $0.leading.equalToSuperview().inset(margin)
            //            $0.trailing.equalTo(contentView.snp.centerX).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
        }
        
        dibsButton.snp.makeConstraints {
            $0.top.equalTo(videoView.snp.bottom).offset(margin)
            $0.trailing.equalToSuperview().inset(margin)
            //            $0.leading.equalTo(contentView.snp.centerX).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
        }
        
    }
    
    //MARK: -Configure
    func configure(/*advertisement: URL, */contentID: Int, contentName: String, dibs: Bool) {
        
        self.contentID = contentID
        headerLabel.text = "절찬 스트리밍 중: \(contentName)"
        
        contentView.reloadInputViews()
    }
    
    //MAKR: -Action
    @objc private func didTabVideoView(sender: UIView) {
        delegate?.didTabVideoView(contentId: contentID!)
    }
    @objc private func didTabPlayButton(sender: UIButton) {
        delegate?.didTabVideoCellPlayButton()
    }
    @objc private func didTabDibsButton(sender: UIButton) {
        // toggle
        delegate?.didTabVideoCellDibsButton()
    }
    @objc private func didTabMuteButton(sender: UIButton) {
        
        if muteFlag == true {
            muteButton.setImage(UIImage(named: "Speaker_icon"), for: .normal)
            player?.isMuted = false
            
            muteFlag = false
        } else {
            muteButton.setImage(UIImage(named: "Mute_icon"), for: .normal)
            player?.isMuted = true
            muteFlag = true
        }

    }
}
