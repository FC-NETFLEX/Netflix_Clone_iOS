//
//  BluredBackgroundView.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/05.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: 상세화면 포스터 뒷편 블러 되어있는 뷰
class BluredBackgroundView: UIView {
    
    private let bluredBackgroundImageView = UIImageView()
    
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    let blackView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setBackgroundImage()
        setConstraints()
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 흐린 배경, 블러 효과, 검은색 뷰 세팅 (스크롤 내리면 검은뷰의 alpha값이 올라가서 흐린 배경 이미지가 보이지 않게 됨)
    private func setBackgroundImage() {
        [bluredBackgroundImageView, blackView, blurEffectView].forEach {
            self.addSubview($0)
        }
        blackView.backgroundColor = .black
        blackView.alpha = 0
//        bluredBackgroundImageView.image = UIImage(named: "yourName") // 서버로부터 받은 이미지 => Fixed
        bluredBackgroundImageView.contentMode = .scaleToFill
        
        bluredBackgroundImageView.clipsToBounds = false
    }
    
    // MARK: 흐린 배경, 블러 효과, 검은색 레이아웃
    private func setConstraints() {
        bluredBackgroundImageView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(CGFloat.dynamicXMargin(margin: -10))
            $0.trailing.equalTo(self.snp.trailing).offset(CGFloat.dynamicXMargin(margin: 10))
            $0.top.equalTo(self.snp.top).offset(CGFloat.dynamicXMargin(margin: -10))
            $0.bottom.equalTo(self.snp.centerY)
        }
        
        blackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(bluredBackgroundImageView)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(self)
        }
    }
    
    // MARK: blackView의 alpha값 조정
    func updateBlurView(alpha: CGFloat) {
        blackView.alpha = alpha
    }
    
    func configure(backgroundImage: String) {
        self.bluredBackgroundImageView.kf.setImage(with: URL(string: backgroundImage))
    }
}

