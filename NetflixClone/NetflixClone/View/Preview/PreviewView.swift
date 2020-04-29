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

protocol PreViewViewDelegate: class {
    func updateProgress(index: Int, time: Int64, duration: Float64)
}

class PreviewView: UIView {
    
    // MARK -
    
    var delegate: PreViewViewDelegate?
    
    private let asset: AVAsset
    var player: AVPlayer
    var playerLayer: AVPlayerLayer
    var durationTime: Float64
    
    private let index: Int
    
    private var backgroundImage = UIImageView()
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    init(url: URL, index: Int) {
        self.index = index
        self.asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        let duration = asset.duration
        self.durationTime = CMTimeGetSeconds(duration)
        
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        super.init(frame: .zero)
        
        playerLayer.videoGravity = .resizeAspectFill
        
        setBlurredBackground()
        
        addTimeObserver()
        
        print("duration Time: ", self.durationTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        removeTimeObserver()
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
    
    private var timeObserver: Any?
    
    private func addTimeObserver() {
        print(#function)
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        let observer = player.addPeriodicTimeObserver(forInterval: time, queue: .main, using: {
            [weak self] time in
            guard let self = self else { return }
            let currentTime = time.value / Int64(NSEC_PER_SEC)
            guard currentTime > 0 else { return }
            print(currentTime)
            self.delegate?.updateProgress(index: self.index, time: currentTime, duration: self.durationTime)
            
        })
        
        timeObserver = observer
    }
    
    private func removeTimeObserver() {
        guard let observer = timeObserver else { return }
        player.removeTimeObserver(observer)
        timeObserver = nil
    }
    
    
    
}







