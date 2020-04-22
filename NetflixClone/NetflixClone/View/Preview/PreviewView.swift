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
    private let asset: AVAsset
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    var durationTime: Float64
    private var blurredBackgroundView = BluredBackgroundView()
    
    init(url: URL) {
        print(url)
        self.asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        let duration = asset.duration
        self.durationTime = CMTimeGetSeconds(duration)
        
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerLayer.videoGravity = .resizeAspectFill
//        setPlayerLayer(url: url)
        
        
        print("duration Time: ", self.durationTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        print(#function)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("영상 끝나면 다음 영상으로 넘겨 줄 것")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setVideo()
    }
    
//    private func setPlayerLayer(url: URL) {
//        let asset = AVAsset(url: url)
//        let playerItem = AVPlayerItem(asset: asset)
//
//        self.player = AVPlayer(playerItem: playerItem)
////        self.playerLayer = AVPlayerLayer(player: self.player)
//
////        guard let playerLayer = self.playerLayer else { return }
//    }
    
    private func setBlurredBackground() {
        self.addSubview(blurredBackgroundView)
        
        blurredBackgroundView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self)
        }
    }
        
    private func setVideo() {
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
    }
    
}


