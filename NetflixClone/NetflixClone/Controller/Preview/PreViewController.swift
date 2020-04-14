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
    private var preview = [PreviewModel]()
    private var previewSubviews = [UIView]()
    var video: String = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/9_03_09_19.mp4"
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        createPreviewSubviews()
        request(id: 2) // 아이디 부분 추후 수정할 것
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        player.play()
    //    }
    
    private func request(id: Int) {
        guard let url = URL(string: "https://www.netflexx.ga/profiles/2/contents/"),
            let token = LoginStatus.shared.getToken()
            else { return }
        APIManager().request(url: url, method: .get, token: token) { (result) in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
//                if let home = try? JSONDecoder().decode(HomeModel.self, from: data) {
//                    self.preview = home.previewContents
//                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUI() {
        view.backgroundColor = .red
        [scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.isPagingEnabled = true
    }
    
    private func createPreviewSubviews() {
        
        for (index, view) in self.preview.enumerated() {
            guard let url = URL(string: view.previewVideo) else { continue }
            let view = PreviewView(url: url)
            
            scrollView.addSubview(view)
            let leading = index == 0 ? scrollView.snp.leading: previewSubviews[index - 1 ].snp.trailing
            
            view.snp.makeConstraints {
                $0.leading.equalTo(leading)
                $0.top.bottom.width.height.equalTo(scrollView)
            }
            
            if index == preview.count - 1 {
                view.snp.makeConstraints {
                    $0.trailing.equalTo(scrollView.snp.trailing)
                }
            }
            
            previewSubviews.append(view)
        }
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
    }
    
}
