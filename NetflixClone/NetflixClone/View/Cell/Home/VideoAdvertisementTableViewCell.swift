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
    func didTapVideoView(contentId: Int) -> ()
    func didTapVideoCellPlayButton(contentId: Int) -> ()
//    func didTabVideoCellDibsButton() -> ()
    func didTapVideoCellDibsButton(id: Int, isEnable: @escaping () -> (), disEnable: () -> (), buttonToogle: (Bool) -> ()) -> ()
}

class VideoAdvertisementTableViewCell: UITableViewCell {
    
    static let identifier = "VideoAdvertisementTC"
    
    weak var delegate: VideoAdvertisementTableViewCellDelegate?
    
    private let headerHeight: CGFloat = 24
    private let videoViewWidth: CGFloat = 375
    private let videoViewHeight: CGFloat = 223

    
    private let headerLabel = UILabel()
    let playButton = UIButton()
    let dibsButton = UIButton()
    
    private let videoView = UIView()
    private let paddingView = UIView()
    private let muteButton = UIButton()
    
    private var muteFlag = true
    
    private var contentID: Int?
    private var dibs: Bool?
    
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
        let buttonFont: UIFont = .systemFont(ofSize: 14)
        headerLabel.font = HeaderFont
        headerLabel.backgroundColor = .clear
        headerLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        
        
        videoView.backgroundColor = .black
        videoView.target(forAction: #selector(didTapVideoView(sender:)), withSender: self)
//        videoView.backgroundColor = UIColor(patternImage: UIImage(named: "NETFLIX_Video")!)
        
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 5
        playButton.setTitle("  재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .black
        playButton.contentHorizontalAlignment = .center
        playButton.titleLabel?.font = buttonFont
        playButton.addTarget(self, action: #selector(didTapPlayButton(sender:)), for: .touchUpInside)
        
        dibsButton.backgroundColor = .gray
        dibsButton.layer.cornerRadius = 5
        dibsButton.setTitle("  내가 찜한 콘텐츠", for: .normal)
        dibsButton.setTitleColor(.white, for: .normal)
        dibsButton.tintColor = .white
        dibsButton.contentHorizontalAlignment = .center
        dibsButton.titleLabel?.font = buttonFont
        dibsButton.addTarget(self, action: #selector(didTapDibsButton(sender:)), for: .touchUpInside)
        
        muteButton.backgroundColor = .clear
        muteButton.setImage(UIImage(named: "Mute_icon"), for: .normal)
        muteButton.addTarget(self, action: #selector(didTapMuteButton(sender:)), for: .touchUpInside)
        
        paddingView.backgroundColor = .clear
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(dibsButton)
        contentView.addSubview(videoView)
        contentView.addSubview(paddingView)
        
        
    }
    
    //MARK: -layoutSubviews
    //layer 위에 음소거 버튼 넣어야 영상위에 셋팅

    override func layoutSubviews() {
        super.layoutSubviews()
        //MARK: -Video
        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoViewWidth, height: videoViewHeight)

        
        videoView.layer.addSublayer(playerLayer)
        
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
    
    func playVideoUrl(url: URL) {
        // url setting
        
        player?.play()
        player?.isMuted = true
    }
    
    
    private func setConstrinats() {

        let margin: CGFloat = 10
        let padding: CGFloat = 4
        
        let buttonHeight: CGFloat = 25
        let buttonWidth: CGFloat = round(contentView.frame.width - (margin * 3) ) / 2
        
        let viewHeight: CGFloat = round(contentView.frame.height / 3 ) * 2
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerHeight - margin)
        }
        
        videoView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(buttonHeight + margin * 2)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        paddingView.snp.makeConstraints {
            $0.top.equalTo(videoView.snp.bottom)
            $0.height.equalTo(margin)
            $0.width.equalTo(margin)
            $0.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints {
            $0.top.equalTo(videoView.snp.bottom).offset(margin)
            $0.leading.equalToSuperview().inset(margin)
            $0.trailing.equalTo(paddingView.snp.leading)
            $0.height.equalTo(buttonHeight)
        }
        
        dibsButton.snp.makeConstraints {
            $0.top.equalTo(videoView.snp.bottom).offset(margin)
            $0.trailing.equalToSuperview().inset(margin)
            $0.leading.equalTo(paddingView.snp.trailing)
            $0.height.equalTo(buttonHeight)
        }
        
    }
    
    //MARK: -Configure
    func configure(/*advertisement: URL, */contentID: Int, contentName: String, dibs: Bool) {
        
        self.contentID = contentID
        headerLabel.text = "절찬 스트리밍 중: \(contentName)"
        self.dibs = dibs
        if dibs {
            dibsButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            dibsButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        
        contentView.reloadInputViews()
    }
    
    //MAKR: -Action
    @objc private func didTapVideoView(sender: UIView) {
        delegate?.didTapVideoView(contentId: contentID!)
    }
    @objc private func didTapPlayButton(sender: UIButton) {
        delegate?.didTapVideoCellPlayButton(contentId: contentID!)
    }
    @objc private func didTapDibsButton(sender: UIButton) {
        delegate?.didTapVideoCellDibsButton(id: contentID!, isEnable: isEnabled, disEnable: disEnabled, buttonToogle: buttonUIToggle(dibsFlag:))
    }
    @objc private func didTapMuteButton(sender: UIButton) {
        
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
    
    //MARK: Button Touch 막기
    func isEnabled() {
        dibsButton.isEnabled = true
        
    }
    
    func disEnabled() {
        dibsButton.isEnabled = false
        
    }
    
    func buttonUIToggle(dibsFlag: Bool) {
        
        if dibsFlag {
            print("true")
            dibsButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            print("false")
            dibsButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            
        }
    }
}
