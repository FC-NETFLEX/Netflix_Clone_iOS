//
//  PreviewView.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/13.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    var blurredBackgroundView = BluredBackgroundView()
    
    init(url: URL) {
        print(url)
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: self.player)
        super.init(frame: .zero)
        playerLayer.videoGravity = .resizeAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVideo()
    }
    
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
