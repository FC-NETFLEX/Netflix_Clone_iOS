//
//  PreviewView.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/13.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PreviewView: UIView {
    
    // MARK - 
    private let asset: AVAsset
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    var durationTime: Float64
    
    private var backgroundImage = UIImageView()
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    init(url: URL) {
        self.asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        let duration = asset.duration
        self.durationTime = CMTimeGetSeconds(duration)
        
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        super.init(frame: .zero)
        
        playerLayer.videoGravity = .resizeAspectFill
        
        setBlurredBackground()
        
        
        print("duration Time: ", self.durationTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        print(#function)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVideo()
    }
    
    private func setBlurredBackground() {
        self.addSubview(backgroundImage)
        self.addSubview(blurEffectView)
        
        backgroundImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self)
        }
    }
    
    private func setVideo() {
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
    }
    
    func configure(image: String) {
        self.backgroundImage.kf.setImage(with: URL(string: image))
    }
}


