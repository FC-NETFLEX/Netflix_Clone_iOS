//
//  PreViewController.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/13.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import AVFoundation

class PreViewController: UIViewController {
    private let videoView = UIView()
    var video: String = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/9_03_09_19.mp4"
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        setVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player.play()
    }
    
    private func setUI() {
        view.backgroundColor = .red
        view.addSubview(videoView)
    }
    
    private func setVideo() {
        let videoUrl = NSURL(fileURLWithPath: video)
        player = AVPlayer(url: videoUrl as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        videoView.layer.addSublayer(playerLayer)
    }
    
    private func setConstraints() {
        videoView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
    }
    

   

}
