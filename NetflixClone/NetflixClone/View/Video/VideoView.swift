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
    
    private let topView = UIView()
    private let exitButton = UIButton()
    private let titleLabel = UILabel()
    
    private let centerView = UIView()
    private let rewindButton = UIButton()
    private let statusButton = UIButton()
    private let slipButton = UIButton()
    
    private let bottomView = UIView()

    
    init(title: String) {
        super.init(frame: .zero)
        setUI(title: title)
        setConstraints()
        setGestureRecognizer()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI(title: String) {
        [backgroundView, topView, centerView, bottomView ].forEach({
            self.addSubview($0)
        })
        
        [titleLabel, exitButton].forEach({
            topView.addSubview($0)
        })
        
    
        topView.backgroundColor = .red
        
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = .setNetfilxColor(name: .white)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
        backgroundView.backgroundColor = .setNetfilxColor(name: .black)
        backgroundView.alpha = 0.5
        
        titleLabel.text = title
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        centerView.backgroundColor = .red
        
        bottomView.backgroundColor = .red
    }
    
    private func setConstraints() {
        
        let topMargin: CGFloat = .dynamicYMargin(margin: 16)
        let trailingMargin: CGFloat = .dynamicXMargin(margin: 32)
        
        
        backgroundView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        topView.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(exitButton)
        })
        
        exitButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-trailingMargin)
            $0.bottom.equalToSuperview()
        })
        
        centerView.snp.makeConstraints({
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        })
        
        bottomView.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
    }
    
    //MARK: Recognize
    
    private func setGestureRecognizer() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
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
    
    @objc private func didDoubleTapView(_ gesture: UITapGestureRecognizer) {
        print(#function)
    }
    
    
}
