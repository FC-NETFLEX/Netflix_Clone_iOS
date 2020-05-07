//
//  VideoControllerViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import AVFoundation
import CoreMedia
import SnapKit


//func step(byCount: Int)
//플레이어 항목의 현재 시간을 지정된 단계 수만큼 앞뒤로 이동합니다.


class VideoController: UIViewController {
    
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    
    private var playerItemContext = UnsafeMutableRawPointer(bitPattern: 0)
    private var timeObserverToken: Any?
    
    private var videoModel: VideoModel!
    private let videoView = VideoView()
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.landscapeRight]
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        setVideoModel(id: id)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let playerLayer = self.playerLayer else { return }
        playerLayer.frame = getVideoLayerFrame()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        removePlayerItemObserver()
        removePeriodicTimeObserver()
        setSavePoint()
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
    
    private func setSavePoint() {
        guard videoModel != nil else { return }
        
        if let savedContent = SavedContentsListModel.shared.getContent(contentID: videoModel.contentID) {
            savedContent.savePoint = videoModel.currentTime == 0 ? nil: videoModel.currentTime
            savedContent.contentRange = videoModel.currentTime == 0 ? nil: videoModel.range
            SavedContentsListModel.shared.putSavedContentsList()
        } else {
            savePointRequest()
        }
    }
    
    private func getVideoLayerFrame() -> CGRect {
        playerLayer?.videoGravity = .resizeAspectFill
        let x = view.bounds.minX + view.safeAreaInsets.left
        let y = view.bounds.minY //+ view.safeAreaInsets.top
        let width = view.bounds.width - (view.safeAreaInsets.left + view.safeAreaInsets.right)
        let heigth = view.bounds.height //- (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let result = CGRect(x: x, y: y, width: width, height: heigth)
        return result
       }
    
    // 마지막 시청 구간 서버에 저장
    private func savePointRequest() {
        
        guard let videoID = videoModel.videoID else { return }
        guard let token = LoginStatus.shared.getToken(), let profileID =  LoginStatus.shared.getProfileID() else { return }
        let bodyData: Data?
        let requestURL: URL
        let method: APIMethod
        
        if let watching = videoModel.watching { // update, delete
            
            let body = ["playtime": videoModel.currentTime]
            guard let url = APIURL.defaultURL.getURL(path: [
            (name: APIPathKey.profiles, value: String(profileID)),
            (name: APIPathKey.watch, value: String(watching.id))
            ]) else { return }
            requestURL = url
            
            if videoModel.currentTime == 0 {
                method = .delete
                bodyData = nil
                
                print("Delete")
            } else {
                guard let data = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
                method = .patch
                bodyData = data
                
                print("Update")
            }
            
        } else { // create
            let body: [String: Any] = ["video": videoID, "playtime": videoModel.currentTime, "video_length": videoModel.range]
            
            guard
                let data = try? JSONSerialization.data(withJSONObject: body, options: []),
                let url = APIURL.defaultURL.getURL(path: [
                (APIPathKey.profiles, String(profileID)),
                (APIPathKey.watch, nil)
            ]) else { return }
            method = .post
            bodyData = data
            requestURL = url
            
            print("Create")
        }
        
        APIManager().request(url: requestURL, method: method, token: token, body: bodyData, completionHandler: {
            result in
            switch result {
            case .success(let data):
                print("WatchingResponse:", String(data: data, encoding: .utf8) ?? "디코딩 실패")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // Model 세팅 -> model세팅이 정상적으로 이루어지지 않으면 해당 컨트롤러를 종료
    private func setVideoModel(id: Int) {
        VideoModel.default(contentID: id, completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                self.unNaturalDismiss()
            case .success(let model):
                self.videoModel = model
                let asset = AVAsset(url: model.videoURL)
                self.setAsset(asset: asset)
                self.videoView.title = model.title
                print(model.videoURL)
            }
        })
    }
    
    // 매개변수로 받은 Double(재생 시간) 부터 재생 시켜주는 함수
    private func seekPlayPoint(seekTime: Int64) {
//        let seekTime = CMTime(value: seekTime, timescale: 1)
//        player?.seek(to: seekTime)
        
        let seekTime = CMTime(seconds: Double(seekTime), preferredTimescale: Int32(NSEC_PER_SEC))
        player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
//        print("SeekTime:", seekTime)
        if player?.timeControlStatus.rawValue != 2 { // playing 상태가 아닐때만 play()
            player?.play()
        }
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
                print("loaded")
            case .loading:
                print("loading")
            case .failed:
                DispatchQueue.main.async {
                    self?.unNaturalDismiss()
                }
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
    private var playerLayer: AVPlayerLayer?
    
    //player 객체 세팅
    private func setPlayer() {
//        print(#function)
        guard let playerItem = self.playerItem else { return }
        let player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = getVideoLayerFrame()
        view.bringSubviewToFront(videoView)
        self.playerLayer = playerLayer
        
        self.player = player
        addPeriodicTimeObserver()
        
    }
    
    private func setPlayerItem(asset: AVAsset) {
        
        let range = asset.duration.value / Int64(asset.duration.timescale)
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
                                options: [.initial, .new, .old,],
                                context: playerItemContext)
    }
    
    
    // 등록해 두었던 playerItem의 옵저버 삭제
    private func removePlayerItemObserver() {
            playerItem?.removeObserver(
                self,
                forKeyPath: #keyPath(AVPlayerItem.status),
                context: playerItemContext)
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
                seekPlayPoint(seekTime: videoModel.currentTime)
                videoView.isLoading = false
            case .failed:
                print(#function)
                print("failed")
                unNaturalDismiss()
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
            guard let self = self else { return }
            
            let currentTime = time.value / Int64(NSEC_PER_SEC)
            guard currentTime > 0 else { return }
            self.videoModel.currentTime = currentTime == self.videoModel.range ? 0: currentTime
            let restTime = self.videoModel.getRestTime(currentTime: currentTime)
            self.videoView.updateTimeSet(currentTime: currentTime, restTime: restTime)
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
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func step(time: Int64) {
        seekPlayPoint(seekTime: time)
    }
    
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
       
    }

}

