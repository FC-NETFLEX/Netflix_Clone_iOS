//
//  VideoControllerViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import AVKit
import CoreMedia

class VideoController: AVPlayerViewController {
    
    private let asset: AVAsset
    private let playerItem: AVPlayerItem
    private var playerItemContext = 0
    private let requiredAssetKeys = ["playable", "hasProtectedContent"]
    private var timeObserverToken: Any?
    private var currentPlayTiime: Int64?
    private var videoModel = VideoModel()
    
    init(url: URL) {
        self.asset = AVAsset(url: url)
        self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: self.requiredAssetKeys)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayer()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        removePlayerItemObserver()
        removePeriodicTimeObserver()
        
    }
    
    //MARK: UI
    
    
    
    
    //MARK: Player
    
    //player 객체 세팅
    private func setPlayer() {
        print(#function)
        addPlayerItemObserver()
        player = AVPlayer(playerItem: playerItem)
        addPeriodicTimeObserver()
    }
    
    
    
     
     
    
    
    //MARK: Action
    
    // 매개변수로 받은 Double(재생 시간) 부터 재생 시켜주는 함수
    private func seekPlayPont(seekTime: Double) {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let seekTime = CMTime(seconds: seekTime, preferredTimescale: timeScale)
        player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    
    

}



    //MARK: Observer
extension VideoController {
    
    // playerItem의 옵저버 등록
    private func addPlayerItemObserver() {
        print(#function)
        playerItem.addObserver(self,
        forKeyPath: #keyPath(AVPlayerItem.status),
        options: [.old, .new,],
        context: &playerItemContext)
        
    }
    
    // 등록해 두었던 playerItem의 옵저버 삭제
    private func removePlayerItemObserver() {
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    // 플레이어아이템의 상태가 바뀔때 호출되는 함수
    // 최초만 호출 하는듯
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(#function)
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
                 player?.play()
             case .failed:
                 print("failed")
                 fallthrough
             case .unknown:
                 print("unknown")
                 fallthrough
             @unknown default:
                 print("default")
                 UIAlertController(title: "영상", message: "다시 시도해 주세요", preferredStyle: .alert)
                    .noticePresent(viewController: self, completion: {
                    [weak self]  in
                    self?.dismiss(animated: true)
                 })
             }
         }
         
     }
     
    
     // player 객체의 현재 재생중인 시간을 0.5초마다 받아서 sel.currentPlayTime에 계산해서 할당
     private func addPeriodicTimeObserver() {
        print(#function)
         let timeScale = CMTimeScale(NSEC_PER_SEC)
         let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
         timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: {
             [weak self] time in
            self?.videoModel.currentTime = time.value / Int64(NSEC_PER_SEC)
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




    //MARK: Test
extension VideoController {
    
}
