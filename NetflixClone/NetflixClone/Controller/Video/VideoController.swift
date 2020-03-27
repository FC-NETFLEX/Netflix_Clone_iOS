//
//  VideoControllerViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import AVKit
import CoreMedia
import SnapKit

class VideoController: UIViewController {
    
    private var isAddPlayerItemObserver = false
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var playerItemContext = 0
    private var timeObserverToken: Any?
    private var videoModel: VideoModel
    
    private let videoView: VideoView
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeRight]
    }
    
    init(url: URL, title: String, savePoint: Int64) {
        self.videoModel = VideoModel(title: title, currentTime: savePoint)
        self.videoView = VideoView(title: title)
        super.init(nibName: nil, bundle: nil)
        setAsset(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        removePlayerItemObserver()
        removePeriodicTimeObserver()
        
    }
    
    //MARK: UI
    
    private func setUI(player: AVPlayer) {
        
        videoView.delegate = self
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        
        view.addSubview(videoView)
        
        setConstraint()
    }
    
    private func setConstraint() {
        videoView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
    
    //MARK: Action
    
    // 매개변수로 받은 Double(재생 시간) 부터 재생 시켜주는 함수
    private func seekPlayPont(seekTime: Double) {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let seekTime = CMTime(seconds: seekTime, preferredTimescale: timeScale)
        player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    
    // 비정상적 종료 할때 알림창 띄운 후 dismiss
    private func unNaturalDismiss() {
        UIAlertController(
            title: "영상", message: "다시 시도해 주세요", preferredStyle: .alert)
            .noticePresent(viewController: self, completion: {
                [weak self]  in
                self?.isAddPlayerItemObserver = false
                self?.exitThisViewController()
            })
    }
    
    private func exitThisViewController() {
        UIView.animate(withDuration: 0.3, animations: { [weak self]  in
            
            self?.view.transform = .init(rotationAngle: -(CGFloat.pi / 2))
            
            self?.view.alpha = 0.1
            
            }, completion: { [weak self] _ in
                
                self?.dismiss(animated: false)
        })
    }
    
    
    //MARK: Asset
    
    
    private func setAsset(url: URL) {
        
        let playableKey = "playable"
        let asset = AVURLAsset(url: url)
        
        asset.loadValuesAsynchronously(forKeys: [playableKey], completionHandler: {
            
            [weak self] in
            
            var error: NSError? = nil
            
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            
            switch status {
            case .loaded:
                
                //                    print("loaded")
                DispatchQueue.main.async {
                    self?.setPlayerItem(asset: asset)
                }
                
            case .loading:
                print("loding")
            case .failed:
                print("failed")
                fallthrough
            case .cancelled:
                print("cancelled")
                fallthrough
            case .unknown:
                print("unknow")
                fallthrough
            @unknown default:
                print("default")
                print(#function)
                self?.unNaturalDismiss()
            }
        })
    }
    
    
    
    
    //MARK: Player
    
    //player 객체 세팅
    private func setPlayer() {
//        print(#function)
        guard let playerItem = self.playerItem else { return }
        let player = AVPlayer(playerItem: playerItem)
        
        setUI(player: player)
        
        self.player = player
        addPeriodicTimeObserver()
    }
    
    private func setPlayerItem(asset: AVAsset) {
        //         print(#function)
        //         playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["playable", "hasProtectedContent"] )
        guard let video = asset.tracks.first(where: { $0.mediaType == .video }) else {
            unNaturalDismiss()
            return
        }
        
        videoModel.range = video.timeRange.duration.value / Int64(video.timeRange.duration.timescale)
        playerItem = AVPlayerItem(asset: asset)
        addPlayerItemObserver()
        setPlayer()
    }
    
    
}



//MARK: Observer
extension VideoController {
    
    // playerItem의 옵저버 등록
    private func addPlayerItemObserver() {
        //        print(#function)
        
        playerItem?.addObserver(self,
                                forKeyPath: #keyPath(AVPlayerItem.status),
                                options: [.new, .old],
                                context: &playerItemContext)
        
    }
    
    // 등록해 두었던 playerItem의 옵저버 삭제
    private func removePlayerItemObserver() {
        if isAddPlayerItemObserver {
            playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        }
    }
    
    
    // 플레이어아이템의 상태가 바뀔때 호출되는 함수
    // 최초만 호출 하는듯
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //        print(#function)
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                //                print("readyToPlay")
                
//                let seekTime = CMTime(seconds: Double(videoModel.currentTime), preferredTimescale: Int32(NSEC_PER_SEC))
//                player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
                let seekTime = CMTime(value: videoModel.currentTime, timescale: 1)
                player?.seek(to: seekTime)
                player?.play()
                
            case .failed:
                print("failed")
                fallthrough
            case .unknown:
                print("unknown")
                fallthrough
            @unknown default:
                print("default")
                print(#function)
                unNaturalDismiss()
            }
            isAddPlayerItemObserver = true
        }
        
    }
    
    
    // player 객체의 현재 재생중인 시간을 0.5초마다 받아서 videoMdel.currentTime에 계산해서 할당
    private func addPeriodicTimeObserver() {
        //        print(#function)
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: {
            [weak self] time in
            self?.videoModel.currentTime = time.value / Int64(NSEC_PER_SEC)
//            print(self?.videoModel.getRestRangeWithString())
//            print(self?.videoModel.range)
        })
        
    }
    
    // 등록했던 player객체의 PeriodicTimeObserver를 remove
    private func removePeriodicTimeObserver() {
        
        if let timeObserverTocken = timeObserverToken {
            player?.removeTimeObserver(timeObserverTocken)
            self.timeObserverToken = nil
        }
        
    }
    
}

//MARK: VideoViewDelegate

extension VideoController: VideoViewDelegate {
    func exitAction() {
        exitThisViewController()
    }
    
    
}


//MARK: Test
extension VideoController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        exitThisViewController()
    }
}
