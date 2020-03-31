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


//func step(byCount: Int)
//플레이어 항목의 현재 시간을 지정된 단계 수만큼 앞뒤로 이동합니다.



class VideoController: UIViewController {
    
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var playerItemContext = UnsafeMutableRawPointer(bitPattern: 0)
    private var timeObserverToken: Any?
    private var videoModel: VideoModel
    private let videoView: VideoView
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeRight]
    }
    
    init(url: URL, title: String, savePoint: Int64) {
        let asset = AVAsset(url: url)
        self.videoModel = VideoModel(title: title, currentTime: savePoint)
        self.videoView = VideoView(title: title)
        super.init(nibName: nil, bundle: nil)
        
        setAsset(asset: asset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraint()
        test()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        removePlayerItemObserver()
        removePeriodicTimeObserver()
    }
    
    //MARK: UI
    
    private func setUI() {
        
        videoView.delegate = self
        view.backgroundColor = .setNetfilxColor(name: .netflixGray)
        view.addSubview(videoView)
        
        
    }
    
    private func setConstraint() {
        let guide = view.safeAreaLayoutGuide
        videoView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalTo(guide)
            $0.trailing.equalTo(guide)
            $0.bottom.equalToSuperview()
        })
    }
    
    //MARK: Action
    
    // 매개변수로 받은 Double(재생 시간) 부터 재생 시켜주는 함수
    private func seekPlayPoint(seekTime: Int64) {
        let seekTime = CMTime(value: seekTime, timescale: 1)
        player?.seek(to: seekTime)
        player?.play()
    }
    
    
    // 비정상적 종료 할때 알림창 띄운 후 dismiss
    private func unNaturalDismiss() {
        UIAlertController(
            title: "영상", message: "재생 실패", preferredStyle: .alert)
            .noticePresent(viewController: self, completion: {
                [weak self]  in
                self?.exitThisViewController()
            })
    }
    
    private func exitThisViewController() {
        UIView.animate(withDuration: 0.3, animations: { [weak self]  in
            
            self?.view.transform = .init(rotationAngle: -(CGFloat.pi / 2))
            
            self?.view.alpha = 0.1
            
            }, completion: { [weak self] isSuccess in
                print("Completion Status :", isSuccess)
                self?.dismiss(animated: false)
        })
    }
    
    private func getAssetImage(time: Int64) -> UIImage? {
           let key = time / 10
        return videoModel.images[key]
       }
       
    
       private func setAssetImages(imageGenerator: AVAssetImageGenerator, range: Int64) {
           
           
           for i in 0...(range / 10) {
               
               let time = CMTime(value: i, timescale: 1)
               let value = NSValue(time: time)
               imageGenerator.generateCGImagesAsynchronously(forTimes: [value], completionHandler: {
                  [weak self] (_, image, _, _, _) in
                   guard let image = image else { return }
                self?.videoModel.images[i] = UIImage(cgImage: image)
               })
           }
           
       }
    
    
    //MARK: Asset
    
    
    private func setAsset(asset: AVAsset) {
        
        let playableKey = "playable"
        
        asset.loadValuesAsynchronously(forKeys: [playableKey], completionHandler: {
            
            [weak self] in
            
            var error: NSError? = nil
            
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            
            switch status {
            case .loaded:
                
                DispatchQueue.main.async {
                    self?.setPlayerItem(asset: asset)
                }
                
            case .loading:
                print("loding")
            case .failed:
                print("failed")
                print(#function)
            case .cancelled:
                print("cancelled")
                print(#function)
            case .unknown:
                print("unknow")
                print(#function)
            @unknown default:
                print("default")
                print(#function)
            }
        })
    }
    
    
    
    
    //MARK: Player
    
    //player 객체 세팅
    private func setPlayer() {
//        print(#function)
        guard let playerItem = self.playerItem else { return }
        let player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        view.bringSubviewToFront(videoView)
        self.player = player
        addPeriodicTimeObserver()
    }
    
    private func setPlayerItem(asset: AVAsset) {
        //         print(#function)
        //         playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["playable", "hasProtectedContent"] )
        
        guard let video = asset.tracks.first(where: { $0.mediaType == .video })  else {
            unNaturalDismiss()
            return
        }
        
        let range = video.timeRange.duration.value / Int64(video.timeRange.duration.timescale)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        setAssetImages(imageGenerator: imageGenerator, range: range)
        
        videoModel.range = range
        videoView.setDefaultSlider(timeRange: range, currentTime: videoModel.currentTime)
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
                                options: [.initial, .new, .old],
                                context: playerItemContext)
        
    }
    
    // 등록해 두었던 playerItem의 옵저버 삭제
    private func removePlayerItemObserver() {
            playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    
    // 플레이어아이템의 상태가 바뀔때 호출되는 함수
    // 최초만 호출 하는듯
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //        print(#function)
        guard context == playerItemContext else {
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
//                let seekTime = CMTime(value: videoModel.currentTime, timescale: 1)
//                player?.seek(to: seekTime)
//                player?.play()
                seekPlayPoint(seekTime: videoModel.currentTime)
                
            case .failed:
                print(#function)
                print("failed")
//                unNaturalDismiss()
            case .unknown:
                print(#function)
                print("unknown")
            @unknown default:
                print(#function)
                print("default")
            }
        }
        
    }
    
    
    // player 객체의 현재 재생중인 시간을 0.5초마다 받아서 videoMdel.currentTime에 계산해서 할당
    private func addPeriodicTimeObserver() {
        //        print(#function)
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: {
            [weak self] time in
            let currentTime = time.value / Int64(NSEC_PER_SEC)
            
            
            guard
                let restTime = self?.videoModel.getRestTime(currentTime: currentTime),
                currentTime > 0
                else { return }
            self?.videoModel.currentTime = currentTime
            self?.videoView.updateTimeSet(currentTime: currentTime, restTime: restTime)
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

private var lastImageRequestTime = Date()

extension VideoController: VideoViewDelegate {
    
    func biganTracking(time: Int64) {
        player?.pause()
        
    }
    
    func changeTracking(time: Int64) -> UIImage? {
        return getAssetImage(time: time)
    }
    
    
    func endTracking(time: Int64) {
        seekPlayPoint(seekTime: time)
    }
    
    func exitAction() {
        exitThisViewController()
    }
    
    
}


//MARK: Test
extension VideoController {
    private func test() {
        videoView.setDefaultSlider(timeRange: 1000, currentTime: videoModel.currentTime)
        
        guard let token = LoginStatus.shared.getToken() else { return }
        APIManager().requestOfPost(url: .iconList, token: token, completion: {
            result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(try? JSONSerialization.jsonObject(with: data, options: []))
            }
        })
    }
    
//    private func getAssetImage(time: Int64, completionHandler: @escaping (CGImage?) -> Void) {
//        let currentTime = Date()
//        let timeInterval = currentTime.timeIntervalSince(lastImageRequestTime)
////        print(timeInterval)
//        guard timeInterval > 0.1 else { return }
//        print(#function)
//        let time = CMTime(value: time, timescale: 1)
//        let value = NSValue(time: time)
//        imageGenerator.cancelAllCGImageGeneration()
//        imageGenerator.generateCGImagesAsynchronously(forTimes: [value], completionHandler: {
//            _, image, _, _, _ in
//            completionHandler(image)
//            lastImageRequestTime = currentTime
//        })
//    }
    
   
}


// func generateThumnailAsync(url: URL, startOffsets: [Double],
//                               completion: @escaping (UIImage) -> Void) {
//        let asset = AVAsset(url: url)
//        let imageGenerator = self.imageGenerator(asset: asset)
//
//        let time: [NSValue] = startOffsets.compactMap {
//            return NSValue(time: CMTimeMakeWithSeconds(Float64($0), asset.duration.timescale))
//        }
//
//        imageGenerator.generateCGImagesAsynchronously(forTimes: time) { _, image, _, _, _ in
//            // 4.
//            if let image = image {
//                completion(UIImage(cgImage: image))
//            }
//        }
//    }
//}
