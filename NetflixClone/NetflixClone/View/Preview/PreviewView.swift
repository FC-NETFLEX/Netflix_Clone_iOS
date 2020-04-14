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
    
    let label = UILabel()
    let playButton = UIButton()
    private let dibsView = CustomButtonView(imageName: "plus", labelText: "내가 찜한 콘텐츠")
    private let infoView = CustomButtonView(imageName: "info.circle", labelText: "정보")
    
    init(url: URL) {
        print(url)
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: self.player)
        super.init(frame: .zero)
        playerLayer.videoGravity = .resizeAspectFill

        setUI()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setVideo()
    }
        
    private func setUI() {
        dibsView.button.tag = 0
        infoView.button.tag = 1
        playButton.tag = 2
        
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.setTitle("▶︎재생", for: .normal)
        playButton.tintColor = .clear
        
        
        dibsView.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        infoView.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    private func setVideo() {
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
    }
    
    private func setContraints() {
        
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
            var dibsButtonClicked = dibsView.isClicked

        switch sender.tag {
        case 0:
            // MARK: 찜하기 버튼 눌렀을 때 액션, 서버로 보내기
            if dibsButtonClicked {
                print("찜하기 버튼 클릭: ", dibsButtonClicked)
                // MARK: 눌렀을 때 애니메이션 (숫자의 크기에 따라서 도는 방향이 결정 됨)
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "checkmark")})

            } else {
                print("찜하기 버튼 풀기: ", dibsButtonClicked)
                // MARK: 찜하기 버튼 한번 더 눌러서 액션 풀기, 서버로 보내기
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi / 2)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "plus")
                })
            }
//            delegate?.dibButtonIsCliked()
            dibsButtonClicked.toggle()

            // 정보버튼 눌렀을 때
        case 1:
            print("정보버튼 눌렀다~")
//            delegate?.infoButtonClicked()
//            infoButtonClicked.toggle()
        case 2:
            print("재생하자~")
        default:
            break
        }
    }
}
