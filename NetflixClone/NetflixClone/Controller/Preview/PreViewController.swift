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
    private var preview = [PreviewContents]()
    private var previewSubviews = [PreviewView]()
    
    private let receivedPreviewIndex: Int
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    private let scrollView = UIScrollView()
    
    init(index: Int = 0) {
        self.receivedPreviewIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        
        request(id: 2) // 아이디 부분 추후 수정할 것
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.setContentOffset(CGPoint(x: CGFloat(receivedPreviewIndex) * scrollView.bounds.width, y: 0), animated: false)
//        previewSubviews[receivedPreviewIndex].player.play()
    }
    
    private func request(id: Int) {
        guard let url = URL(string: "https://www.netflexx.ga/profiles/\(id)/contents/"),
            let token = LoginStatus.shared.getToken()
            else { return }
        APIManager().request(url: url, method: .get, token: token) { (result) in
            switch result {
            case .success(let data):

                
                if let home = try? JSONDecoder().decode(HomeContent.self, from: data) {
                    self.preview = home.previewContents
                    self.createPreviewSubviews()
                }
                
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
        [scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
    }
    
    private func createPreviewSubviews() {
        self.previewSubviews = preview.compactMap {
            guard let url = URL(string: $0.previewVideoURL) else {
                print("makeURL Fail")
                return nil
            }
            let view = PreviewView(url: url)
            print()
            return view
        }
        
        //        let colors = [UIColor.gray, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.darkGray, UIColor.purple, UIColor.white, UIColor.brown]
        //        var views: [UIView] = []
        //        colors.forEach({
        //            let view = UIView()
        //            view.backgroundColor = $0
        //            views.append(view)
        //        })
        
        for (index, view) in previewSubviews.enumerated() {
            scrollView.addSubview(view)
            //            let leading = index == 0 ? scrollView.snp.leading : previewSubviews[index-1].snp.trailing
            let leading = index == 0 ? scrollView.snp.leading : previewSubviews[index-1].snp.trailing
            view.backgroundColor = random
            view.snp.makeConstraints {
                $0.leading.equalTo(leading)
                $0.top.bottom.width.height.equalTo(scrollView)
            }
            
            if index == previewSubviews.count - 1 {
                view.snp.makeConstraints {
                    $0.trailing.equalTo(scrollView.snp.trailing)
                }
            }
            
        }
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
    }
    
}

var random: UIColor {
    get {
        let min: CGFloat = 0.1
        let max: CGFloat = 0.9
        let red = CGFloat.random(in: min ... max)
        let green = CGFloat.random(in: min ... max)
        let blue = CGFloat.random(in: min ... max)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension PreViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let displayingViewIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        previewSubviews[displayingViewIndex].player.play()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previewSubviews.forEach {
            $0.player.pause()
        }
    }
    
    
}
