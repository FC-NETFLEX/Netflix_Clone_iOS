//
//  HomeMenuBarView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/19.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol HomeMenuBarViewDelegate: class {
    func didTabMenuBarIconButton() -> ()
    func didTabMenuBarMovieButton() -> ()
    func didTabCategoryButton() -> ()
    func didTabDibsButton() -> ()
}

// view의 frame -> 1/9
class HomeMenuBarView: UIView {
    
    weak var delegate: HomeMenuBarViewDelegate?
    
    private let iconButton = UIButton()
    
    private let movieButton = UIButton()
    private let categoryButton = UIButton()
    private let dibsButton = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        // 생성될 때 animation,
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    private func setUI() {
        let fontColor: UIColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        let buttonFont: UIFont = .boldSystemFont(ofSize: 14)
        
        iconButton.setImage(UIImage(named: "netflixIcon"), for: .normal)
        iconButton.contentMode = .scaleAspectFill
        iconButton.backgroundColor = .clear
        iconButton.addTarget(self, action: #selector(didTabIconButton(sender:)), for: .touchUpInside)
        
        movieButton.setTitle("영화", for: .normal)
        movieButton.backgroundColor = .clear
        movieButton.setTitleColor(fontColor, for: .normal)
        movieButton.titleLabel?.font = buttonFont
        movieButton.addTarget(self, action: #selector(didTabmoviewButton(sender:)), for: .touchUpInside)
        
        categoryButton.setTitle("카테고리 ▼", for: .normal)
        categoryButton.backgroundColor = .clear
        categoryButton.setTitleColor(fontColor, for: .normal)
        categoryButton.titleLabel?.font = buttonFont
        categoryButton.addTarget(self, action: #selector(didTabCategoryButton(sender:)), for: .touchUpInside)
        
        dibsButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        dibsButton.backgroundColor = .clear
        dibsButton.setTitleColor(fontColor, for: .normal)
        dibsButton.titleLabel?.font = buttonFont
        dibsButton.addTarget(self, action: #selector(didTabDibsButton(sender:)), for: .touchUpInside)
        
        [iconButton, movieButton, categoryButton, dibsButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        let margin: CGFloat = 16
        let buttonHeight: CGFloat = 30
        let movieWidth: CGFloat = 50
        let categoryWidth: CGFloat = 100
        let dibsWidth: CGFloat = 150
        
//        let top: CGFloat = UIScreen.accessibilityFrame().frame
        let top: CGFloat = 30
        
        
        iconButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin + top)
            $0.leading.equalToSuperview().inset(margin)
            $0.height.width.equalTo(buttonHeight)
        }
        
        movieButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin + top)
            $0.leading.equalTo(iconButton.snp.trailing).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(movieWidth)
        }
        
        categoryButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin + top)
            $0.leading.equalTo(movieButton.snp.trailing).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(categoryWidth)
        }
        
        dibsButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin + top)
            $0.leading.equalTo(categoryButton.snp.trailing).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(dibsWidth)
        }
    }
    
    //MARK: Action
    @objc private func didTabIconButton(sender: UIButton) {
        backgroundColor = .clear
        movieButton.setTitle("영화", for: .normal)
        dibsButton.setTitle("내가 찜한 콘텐츠", for: .normal)

        delegate?.didTabMenuBarIconButton()
    }
    
    @objc private func didTabmoviewButton(sender: UIButton) {
        backgroundColor = .clear
        movieButton.setTitle("영화 ▼", for: .normal)
        
        delegate?.didTabMenuBarMovieButton()
    }
    @objc private func didTabCategoryButton(sender: UIButton) {
        
        delegate?.didTabCategoryButton()
    }
    
    @objc private func didTabDibsButton(sender: UIButton) {
        print("HomeMenuBar")
        backgroundColor = .black
        dibsButton.setTitle("내가 찜한 콘텐츠 ▼", for: .normal)
        delegate?.didTabDibsButton()
    }
    
}
