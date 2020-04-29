//
//  HomeMenuBarView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/19.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

/*
 didscroll alpha
 */


protocol HomeMenuBarViewDelegate: class {
    func didTapMenuBarIconButton() -> ()
    func didTapMenuBarMovieButton() -> ()
    func didTapCategoryButton() -> ()
    func didTapDibsButton() -> ()
}

// view의 frame -> 1/9
class HomeMenuBarView: UIView {
    
    weak var delegate: HomeMenuBarViewDelegate?
    
    private let iconButton = UIButton()
    
    private let movieButton = UIButton()
    let categoryButton = UIButton()
    private let dibsButton = UIButton()
    
    private let margin: CGFloat = 16

    
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
        movieButton.addTarget(self, action: #selector(didTapmoviewButton(sender:)), for: .touchUpInside)
        
        categoryButton.setTitle("카테고리 ▼", for: .normal)
        categoryButton.backgroundColor = .clear
        categoryButton.setTitleColor(fontColor, for: .normal)
        categoryButton.titleLabel?.font = buttonFont
        categoryButton.addTarget(self, action: #selector(didTapCategoryButton(sender:)), for: .touchUpInside)
        categoryButton.isHidden = true
        
        dibsButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        dibsButton.backgroundColor = .clear
        dibsButton.setTitleColor(fontColor, for: .normal)
        dibsButton.titleLabel?.font = buttonFont
        dibsButton.addTarget(self, action: #selector(didTapDibsButton(sender:)), for: .touchUpInside)
        
        [iconButton, movieButton, categoryButton, dibsButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
//        let margin: CGFloat = 16
        let buttonHeight: CGFloat = 30
        let movieWidth: CGFloat = 50
        let categoryWidth: CGFloat = 80
        let dibsWidth: CGFloat = 120
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
//            $0.leading.equalTo(iconButton.snp.trailing).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(categoryWidth)
        }
        
        dibsButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin + top)
//            $0.leading.equalTo(categoryButton.snp.trailing).offset(margin)
            $0.leading.equalTo(movieButton.snp.trailing).offset(margin)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(dibsWidth)
        }
    }
    
    //MARK: Action
    @objc private func didTabIconButton(sender: UIButton) {
        backgroundColor = .clear
        movieButton.setTitle("영화", for: .normal)
        dibsButton.setTitle("내가 찜한 콘텐츠", for: .normal)

        delegate?.didTapMenuBarIconButton()
    }
    
    @objc private func didTapmoviewButton(sender: UIButton) {
        backgroundColor = .clear
        
        delegate?.didTapMenuBarMovieButton()
    }
    @objc private func didTapCategoryButton(sender: UIButton) {
        
        delegate?.didTapCategoryButton()
    }
    
    @objc private func didTapDibsButton(sender: UIButton) {
        backgroundColor = .black
        dibsButton.setTitle("내가 찜한 콘텐츠 ▼", for: .normal)
        delegate?.didTapDibsButton()
    }
    
    //MARK: Animation
    //원상복귀.
    func swingBackAnimation() {
        //다 히든했다가 위치 딱 잡아주고 천천히 알파값 주기.
        dibsButton.isHidden = true
//        categoryButton.isHidden = true
        movieButton.isHidden = true
        
        dibsButton.alpha = 0
        categoryButton.alpha = 0
        movieButton.alpha = 0
        
        dibsButton.removeFromSuperview()
        categoryButton.removeFromSuperview()
        movieButton.removeFromSuperview()
        
        setUI()
        setConstraints()

        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.dibsButton.isHidden = false
//                self.categoryButton.isHidden = false
                self.movieButton.isHidden = false
                
                self.dibsButton.alpha = 1
//                self.categoryButton.alpha = 1
                self.movieButton.alpha = 1
        })
    }
    
    //내가찜한 컨텐츠 클릭시 애니메이션
    func dibsClickAnimation() {
        let iconX = iconButton.frame.maxX
        let dibsX = dibsButton.frame.midX
        let finalDibsX = dibsX - (margin * 4 + iconX)
        
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.dibsButton.center.x -= finalDibsX
                self.movieButton.alpha = 0
                
        })
        movieButton.isHidden = true

    }
    
    func movieClickAnimation() {
        let iconX = iconButton.frame.maxX
//        let categoryX = dibsButton.frame.midX - (iconX)
        let categoryFrame = categoryButton.frame
//        print("iconX = \(iconX), dibsX = \(categoryX)")
        
        categoryButton.frame = .init(x: movieButton.frame.minX, y: movieButton.frame.minY, width: 1, height: 1)
        categoryButton.isHidden = false
        categoryButton.alpha = 0
        
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.categoryButton.frame = categoryFrame

                UIView.addKeyframe(
                    withRelativeStartTime: 0.3,
                    relativeDuration: 0,
                    animations: {
                        self.categoryButton.alpha = 1

                })

        })
        
        dibsButton.isHidden = true
    }
    
}
