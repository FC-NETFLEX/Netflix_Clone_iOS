//
//  LogoView.swift
//  PreviewExample
//
//  Created by MyMac on 2020/04/16.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class LogoView: UIView {
    let progressView = UIProgressView()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [progressView, imageView].forEach {
            self.addSubview($0)
        }
        progressView.tintColor = .lightGray
        progressView.progressTintColor = .white
        imageView.contentMode = .scaleToFill
    }
    
    func setConstraints() {
        let insetValue: CGFloat = CGFloat.dynamicYMargin(margin: 10)
        let progressBarHeight = CGFloat.dynamicYMargin(margin: 3)
        
        progressView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(insetValue)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(CGFloat.dynamicYMargin(margin: progressBarHeight))
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(insetValue)
            $0.leading.equalToSuperview().inset(insetValue)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(logoNamed: String) {
        self.imageView.kf.setImage(with: URL(string: logoNamed))
    }
    
    func progressConfigure(currentTime: Int64, duration: Float64) {
        let currentPlayBackPoint = Float(currentTime) / Float(duration)
        progressView.setProgress(currentPlayBackPoint, animated: true)
    }
    
}

