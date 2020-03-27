//
//  VideoView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol VideoViewDelegate: class {
    func exitAction()
}

class VideoView: UIView {
    
    weak var delegate: VideoViewDelegate?
    
    private let backgroundView = UIView()
    
    private let exitButton = UIButton()
    private let titleLabel = UILabel()
    
    private let rewindButton = UIButton()
    private let statusButton = UIButton()
    private let slipButton = UIButton()
    
    

    
    init(title: String) {
        super.init(frame: .zero)
        setUI(title: title)
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI(title: String) {
        [backgroundView, titleLabel, exitButton].forEach({
            self.addSubview($0)
        })
        
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = .setNetfilxColor(name: .white)
        
        backgroundView.backgroundColor = .setNetfilxColor(name: .black)
        backgroundView.alpha = 0.5
        
        titleLabel.text = title
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        
    }
    
    private func setConstraints() {
        
        let topMargin: CGFloat = .dynamicYMargin(margin: 16)
        let trailingMargin: CGFloat = .dynamicYMargin(margin: 40)
        
        
        backgroundView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(topMargin)
        })
        
        exitButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(topMargin)
            $0.trailing.equalToSuperview().offset(-trailingMargin)
            
        })
        
        
    }
    
    
    //MARK: Action
    
    private func appearView() {
        let alpha: CGFloat = 0.7
        self.alpha = alpha
    }
    
    private func disAppearView() {
        let alpha: CGFloat = 0
        self.alpha = alpha
    }
    
    @objc private func didTapExitButton() {
        delegate?.exitAction()
    }
    
}
