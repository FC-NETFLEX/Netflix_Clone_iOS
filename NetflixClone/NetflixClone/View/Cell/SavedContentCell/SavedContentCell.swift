//
//  SavedContentCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

protocol SavedContentCellDelegate: class {
    func saveContentControl(status: SaveContentStatus, id: Int)
    func presentVideonController(contentID: Int)
}

class SavedContentCell: UITableViewCell {
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        switch hitView {
//        case playImageView, playImageBackgroundView:
//            return thumbnailImageView
//        default:
//            return hitView
//        }
//    }
    
    static let identifier = "SavedContentCell"
    
    weak var delegate: SavedContentCellDelegate?
    
    
    private let thumbnailImageView = UIImageView()
    private let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
    private let playImageBackgroundView = CircleView()
    private let playButton = UIButton()
    
    private let summaryLabel = UILabel()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusView: SaveContentStatusView
    
    
    init(id: Int, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.statusView = SaveContentStatusView(id: id, status: .saved)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .black)
        [summaryLabel, thumbnailImageView, playButton, titleLabel, descriptionLabel, statusView].forEach({
            contentView.addSubview($0)
        })
        
        
//        let sizeGuide = UIScreen.main.bounds.height / 7
        
        selectionStyle = .none
        
        [playImageBackgroundView].forEach({
            thumbnailImageView.addSubview($0)
        })
        
        playImageBackgroundView.addSubview(playImageView)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        playButton.addTarget(self, action: #selector(didPlayButton), for: .touchUpInside)
        
        playImageView.contentMode = .scaleAspectFit
        playImageView.tintColor = .setNetfilxColor(name: .white)
        
        thumbnailImageView.backgroundColor = .setNetfilxColor(name: .netflixDarkGray)
        
        playImageBackgroundView.layer.borderColor = UIColor.setNetfilxColor(name: .white).cgColor
        playImageBackgroundView.layer.borderWidth = 1
        playImageBackgroundView.backgroundColor = UIColor.setNetfilxColor(name: .black).withAlphaComponent(0.3)
        
        
        let titleFontSize: CGFloat = 16
        titleLabel.font = .dynamicFont(fontSize: titleFontSize, weight: .heavy)
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        descriptionLabel.font = .dynamicFont(fontSize: titleFontSize * 0.7, weight: .light)
        descriptionLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        
        summaryLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        summaryLabel.font = .dynamicFont(fontSize: titleFontSize * 0.8, weight: .regular)
        summaryLabel.numberOfLines = 0
        
        statusView.addTarget(self, action: #selector(didTapStatusView(_:)), for: .touchUpInside)
        
    }
    
    private func setConstraint() {
        let xMargin = CGFloat.dynamicXMargin(margin: 16)
        let yMargin = CGFloat.dynamicYMargin(margin: 4)
        
        let xPading = CGFloat.dynamicXMargin(margin: 8)
        
        
        thumbnailImageView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
            $0.top.bottom.equalToSuperview().inset(yMargin)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.3)
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.6)
        })
        
        playImageBackgroundView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailImageView.snp.height).multipliedBy(0.5)
        })
        
        playImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(playImageBackgroundView.snp.height).multipliedBy(0.5)
        })
        
        playButton.snp.makeConstraints({
            $0.leading.top.trailing.bottom.equalTo(thumbnailImageView)
        })
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.bottom.equalTo(thumbnailImageView.snp.centerY)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.top.equalTo(thumbnailImageView.snp.centerY)
        })
        
        statusView.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-xMargin)
            $0.centerY.equalTo(thumbnailImageView)
            $0.height.width.equalTo(thumbnailImageView.snp.height).multipliedBy(0.5)
        })
        
        summaryLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(xMargin)
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.bottom.equalToSuperview()
        })
        
    }
    
    
    //MARK: Action
    func configure(content: SaveContent) {
        
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        thumbnailImageView.kf.setImage(with: content.imageURL)
        summaryLabel.text = content.isSelected ? content.summary: ""
        statusView.downLoadStatus = content.status
        statusView.id = content.contentID
    }
    
    
    @objc private func didTapStatusView(_ sender: SaveContentStatusView) {
        delegate?.saveContentControl(status: sender.downLoadStatus, id: sender.id)
    }
    
    @objc private func didPlayButton(_ sender: UIButton) {
        print(#function)
        delegate?.presentVideonController(contentID: statusView.id)
    }
    
//    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
//        UIEditingInteractionConfiguration
//    }
        
}


