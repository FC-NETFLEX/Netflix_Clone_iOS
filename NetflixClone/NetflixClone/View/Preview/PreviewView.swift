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
    func playerDidFinishPlaying(note: NSNotification)
}

class PreviewView: UIView {
    
    // blurView animation으로 인한 터치 이벤트를 스크롤뷰가 가져가지 못하는 부분 해결
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }

    
    // MARK -
    
    var delegate: PreViewViewDelegate?
    
//    private let asset: AVAsset
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var durationTime: Float64 = 0
    
    private let url: URL
    private let index: Int
    
    private var timeObserver: Any?
    
    private var backgroundImage = UIImageView()
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    var isWaiting = false {
        didSet {
            if !oldValue && self.isWaiting {
                waitingAnimation()
            }
        }
    }

    
    init(url: URL, index: Int) {
        self.index = index
        self.url = url
//        self.asset = AVAsset(url: url)
//        let playerItem = AVPlayerItem(asset: asset)
//        let duration = asset.duration
//        self.durationTime = CMTimeGetSeconds(duration)
//        self.player = AVPlayer(playerItem: playerItem)
//        self.playerLayer = AVPlayerLayer(player: self.player)
        
        super.init(frame: .zero)
        print("Finished previewView init")
        
        
        
        setBlurredBackground()
        
        
        
//        print("duration Time: ", self.durationTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removePlayerFinishedObserver()
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
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
    }
    
    func configure(image: String) {
        self.backgroundImage.kf.setImage(with: URL(string: image))
    }
    
    
    
    private func addTimeObserver(player: AVPlayer) {
        print(#function)
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        let observer = player.addPeriodicTimeObserver(forInterval: time, queue: .main, using: {
            [weak self] time in
            guard let self = self else { return }
            let currentTime = time.value / Int64(NSEC_PER_SEC)
            guard currentTime > 0 else { return }
//            print("time", currentTime, "index:", self.index)
            self.delegate?.updateProgress(index: self.index, time: currentTime, duration: self.durationTime)

        })

        timeObserver = observer
    }
    
    private func removeTimeObserver() {
        guard let observer = timeObserver else { return }
        player?.removeTimeObserver(observer)
        timeObserver = nil
    }
    
    private func setPlayer() {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        durationTime = CMTimeGetSeconds(asset.duration)
        addTimeObserver(player: player)
        addPlayerFinishedObserver(player: player)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.playerLayer = AVPlayerLayer(player: player)
            self.setVideo()
            player.play()
        }
    }
    
    private func addPlayerFinishedObserver(player: AVPlayer) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    private func removePlayerFinishedObserver() {
        guard let player = player else { return }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        delegate?.playerDidFinishPlaying(note: note)
        
    }
    
    
    // Player의 셋팅을 기다리면서 blurView 의 alpha 를 조정해 주는 애니메이션
    private func waitingAnimation() {
//        print(#function, index)
        guard player == nil else { return }
        
        let alpha = self.blurEffectView.alpha == 1 ? 0.7: 1
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.blurEffectView.alpha = CGFloat(alpha)
            }, completion: {
                [weak self] _ in
                guard let self = self else { return }
                self.waitingAnimation()
        })
    }
        
    func playPreview() {
        if let player = player {
            player.play()
        } else {
            isWaiting = true
            DispatchQueue.global().async { [weak self] in
                self?.setPlayer()
            }
        }
    }
    
    func pausePreview() {
        player?.pause()
    }
    
    func seekPreview(to time: CMTime) {
        player?.seek(to: time)
    }
    
    
}







