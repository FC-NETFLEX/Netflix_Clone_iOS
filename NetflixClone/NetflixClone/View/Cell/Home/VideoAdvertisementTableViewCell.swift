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
    func didTabVideoView() -> ()
    func didTabPlayButton() -> ()
    func didTabDibsButton() -> ()
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
    
    private let urlString = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/videoplayback.mp4"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
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
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(dibsButton)
        contentView.addSubview(videoView)
        
        videoView.addSubview(muteButton)
        
    }
    
    //MARK: -layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        print("VideoAdvertisementTableViewCell: layoutSubviews videoView.frame = \(videoView.frame)")
        //MARK: -Video
        guard let url = URL(string: urlString) else { return  print("url setVideo 강제종료")}
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
//        playerLayer.frame = videoView.frame
        
        videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    

    
    private func setConstrinats() {
        let headerYMargin: CGFloat = 10
        let headerXMargin: CGFloat = 10
        
        let margin: CGFloat = 10
        

        let buttonHeight: CGFloat = 25
        let buttonWidth: CGFloat = round(contentView.frame.width - (margin * 3) ) / 2
        
        let viewHeight: CGFloat = round(contentView.frame.height / 3 ) * 2

        
        
        print("VideoAdvertisementTableViewCell: contentView \(contentView.frame), height \(contentView.frame.height), viewHeight: \(viewHeight), buttonWidth: \(buttonWidth)")
        
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
        
        //muteButton
        
        print("VideoAdvertisementTableViewCell: Constraints videoView.frame = \(videoView.frame)")

    }
    
    //MARK: -Configure
    func configure(advertisement: URL, contentID: Int, contentName: String, dibs: Bool) {
        
        headerLabel.text = "절찬 스트리밍 중: \(contentName)"
        
        
    }
    
    //MAKR: -Action
    @objc private func didTabVideoView(sender: UIView) {
        delegate?.didTabVideoView()
    }
    @objc private func didTabPlayButton(sender: UIButton) {
        delegate?.didTabPlayButton()
    }
    @objc private func didTabDibsButton(sender: UIButton) {
        // toggle
        delegate?.didTabDibsButton()
    }
}
