//
//  HomeviewTitle.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeviewTitleDelegate: class {
    func didTapHomeTitledibsButton(id: Int, isEnable: @escaping () -> (), disEnable: () -> (), buttonToogle: (Bool) -> ()) -> ()
    func didTapHomeTitlePlayButton() -> ()
    func didTapHomeTitleContentButton() -> ()
}

class HomeviewTitle: UIView {
    
    weak var delegate: HomeviewTitleDelegate?
    
    private let titlePoster = UIImageView()
    private let topGradient = CAGradientLayer()
    private let bottomGradient = CAGradientLayer()
    
    private let contentView = UIView()
    private let categoryLabel = UILabel()
    private let dibsButton = UIButton()
    private let playButton = UIButton()
    private let infoButton = UIButton()
    
    private let dibsLabel = UILabel()
    private let infoLabel = UILabel()
    
    private let titleImage = UIImageView()
    
    private var id: Int?
    private var dibs: Bool?
    
    //    private let gradientLayer: CAGradientLayer = {
    //        let gradientLayer = CAGradientLayer()
    //        gradientLayer.backgroundColor = UIColor.clear.cgColor
    //        gradientLayer.colors = [UIColor.black.cgColor, UIColor.gray.cgColor, UIColor.clear.cgColor]
    //        return gradientLayer
    //    }()
    
    private let gradationLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        
        let textTintColor: UIColor = .white
        let categoryFont: UIFont = .boldSystemFont(ofSize: 12)
        let fixedFont: UIFont = .systemFont(ofSize: 12)
        
        //        titlePoster.contentMode = .scaleAspectFit
        titlePoster.contentMode = .scaleAspectFill
        titlePoster.clipsToBounds = true
        
        categoryLabel.textColor = textTintColor
        categoryLabel.font = categoryFont
        
        
        dibsButton.tintColor = textTintColor
        dibsButton.addTarget(self, action: #selector(didTapdibsButton(sender:)), for: .touchUpInside)
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.contentHorizontalAlignment = .center
        playButton.setTitle("   재생", for: .normal)
        playButton.titleLabel?.font = fixedFont
        playButton.setTitleColor(.black, for: .normal)
        playButton.layer.cornerRadius = 2
        playButton.tintColor = .black
        playButton.backgroundColor = textTintColor
        playButton.addTarget(self, action: #selector(didTapPlayButton(sender:)), for: .touchUpInside)
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(didTapInfoButton(sender:)), for: .touchUpInside)
        infoButton.tintColor = textTintColor
        
        titleImage.contentMode = .scaleAspectFit
        //        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        
        
        dibsLabel.text = "내가 찜한 콘텐츠"
        dibsLabel.font = fixedFont
        dibsLabel.textColor = textTintColor
        
        
        infoLabel.text = "정보"
        infoLabel.font = fixedFont
        infoLabel.textColor = textTintColor
        
        
        addSubview(titlePoster)
        
        addSubview(contentView)
        addSubview(titleImage)
        
        [categoryLabel, dibsButton, playButton, infoButton, dibsLabel, infoLabel].forEach {
            contentView.addSubview($0)
        }
        
        
    }
    
    
    private func setConstraints() {
        
        let xMargin: CGFloat = CGFloat.dynamicXMargin(margin: 20)
        let yMargin: CGFloat = CGFloat.dynamicYMargin(margin: 8)
        let padding: CGFloat = 8
        
        let miniButtonWidth: CGFloat = xMargin * 2
        let miniButtonHeight: CGFloat = yMargin * 4
        
        
        titlePoster.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.16)
        }
        
        titleImage.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.2)
            
        }
        
        dibsLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(yMargin)
            $0.leading.equalToSuperview().inset(xMargin + padding)
            $0.height.equalTo(miniButtonHeight)
        }
        
        infoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(yMargin)
            $0.trailing.equalToSuperview().inset(xMargin + padding * 2)
            $0.height.equalTo(miniButtonHeight)
        }
        
        dibsButton.snp.makeConstraints {
            $0.bottom.equalTo(dibsLabel.snp.top).inset(yMargin)
            $0.centerX.equalTo(dibsLabel.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWidth)
            
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).inset(yMargin)
            $0.centerX.equalTo(infoLabel.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalTo(miniButtonWidth)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(titlePoster.snp.centerX)
            $0.height.equalTo(miniButtonHeight)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(playButton.snp.top).inset(-yMargin)
            $0.centerX.equalTo(titlePoster.snp.centerX)
        }
        
        
        
    }
    
    //MARK: - Gradient(그라데이션)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomGradient.startPoint = CGPoint(x: 1, y: 1)
        bottomGradient.endPoint = CGPoint(x: 1, y: 0.5)
        bottomGradient.colors = [
            #colorLiteral(red: 0.07841768116, green: 0.07843924314, blue: 0.07841629535, alpha: 1).cgColor,
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        bottomGradient.locations = [0, 1]
        bottomGradient.frame = CGRect(origin: .zero, size: frame.size)
        
        
        topGradient.startPoint = CGPoint(x: 0, y: 0)
        topGradient.endPoint = CGPoint(x: 0, y: 0.3)
        topGradient.colors = [
            #colorLiteral(red: 0.07841768116, green: 0.07843924314, blue: 0.07841629535, alpha: 1).cgColor,
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        topGradient.locations = [0, 1]
        topGradient.frame = CGRect(origin: .zero, size: frame.size)
        
        
        titlePoster.layer.addSublayer(bottomGradient)
        titlePoster.layer.addSublayer(topGradient)
    }
    
    
    
    // MARK: - configure
    func configure(id: Int, poster: String, categories: [String], dibs: Bool, titleImage: String /*, url: URL?*/) {
        self.id = id
        self.dibs = dibs
        
        if dibs {
            dibsButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            dibsButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        
        
        var categoryText: String = ""

        var forNum = 0
        for category in categories {
            forNum += 1
            categoryText += category
            if forNum == categories.count {
                continue
            }
            categoryText += " ・ "
        }
        
        titlePoster.kf.setImage(with: URL(string: poster))
        categoryLabel.text = categoryText
        self.titleImage.kf.setImage(with: URL(string: titleImage))
        
    }
    
    //MARK: - action
    @objc private func didTapdibsButton(sender: UIButton) {
        delegate?.didTapHomeTitledibsButton(id: id!, isEnable: isEnabled, disEnable: disEnabled, buttonToogle: buttonUIToggle(dibsFlag:) )
    }
    
    @objc private func didTapPlayButton(sender: UIButton) {
        delegate?.didTapHomeTitlePlayButton()
    }
    
    @objc private func didTapInfoButton(sender: UIButton) {
        delegate?.didTapHomeTitleContentButton()
    }
    
    
    //MARK: Button Touch 막기
    func isEnabled() {
        dibsButton.isEnabled = true
        
    }
    
    func disEnabled() {
        dibsButton.isEnabled = false
        
    }
    
    func buttonUIToggle(dibsFlag: Bool) {
        
        if dibsFlag {
            dibsButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            dibsButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            
        }
    }
    
}
