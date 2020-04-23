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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        switch hitView {
        case playImageView, playImageBackgroundView:
            return thumbnailView
        default:
            return hitView
        }
    }
    
    static let identifier = "SavedContentCell"
    
    weak var delegate: SavedContentCellDelegate?
    
    private let thumbnailView = UIButton()
    private let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
    private let playImageBackgroundView = CircleView()
    
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
        [summaryLabel, thumbnailView, titleLabel, descriptionLabel, statusView].forEach({
            contentView.addSubview($0)
        })
        
//        let sizeGuide = UIScreen.main.bounds.height / 7
        
        selectionStyle = .none
        
        thumbnailView.addSubview(playImageBackgroundView)
        
        playImageBackgroundView.addSubview(playImageView)
        
        thumbnailView.contentMode = .scaleToFill
        thumbnailView.addTarget(self, action: #selector(didTapThumbnailView(_:)), for: .touchUpInside)
        
        
        playImageView.contentMode = .scaleAspectFit
        playImageView.tintColor = .setNetfilxColor(name: .white)
        
        thumbnailView.backgroundColor = .setNetfilxColor(name: .netflixDarkGray)
        
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
        let yMargin = CGFloat.dynamicYMargin(margin: 8)
        
        let xPading = CGFloat.dynamicXMargin(margin: 8)
        
        
        thumbnailView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
            $0.top.equalToSuperview().inset(yMargin)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.3)
            $0.height.equalTo(thumbnailView.snp.width).multipliedBy(0.6)
        })
        
        playImageBackgroundView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(thumbnailView.snp.height).multipliedBy(0.5)
        })
        
        playImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(playImageBackgroundView.snp.height).multipliedBy(0.5)
        })
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.bottom.equalTo(thumbnailView.snp.centerY)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(xPading)
            $0.trailing.equalTo(statusView.snp.leading).offset(-xPading)
            $0.top.equalTo(thumbnailView.snp.centerY)
        })
        
        statusView.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-xMargin)
            $0.centerY.equalTo(thumbnailView)
            $0.height.width.equalTo(thumbnailView.snp.height).multipliedBy(0.5)
        })
        
        summaryLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(xMargin)
            $0.top.equalTo(thumbnailView.snp.bottom)
            $0.bottom.equalToSuperview()
        })
        
    }
    
    
    //MARK: Action
    
    private func setImage(imageURL: URL) {
        KingfisherManager.shared.retrieveImage(with: imageURL, completionHandler: {
            [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self?.thumbnailView.setImage(data.image, for: .normal)
            }
        })
    }
    
    func configure(content: SaveContent) {
        
        var capacityDescription: String = ""
        
        if let capacity = content.capacity, let capacityString = switchMBForKB(capacity: capacity) {
            capacityDescription = " | " + String(capacityString) + "MB"
        }
        
        titleLabel.text = content.title
        descriptionLabel.text = content.rating + capacityDescription
        setImage(imageURL: content.imageURL)
        summaryLabel.text = content.isSelected ? content.summary: ""
        statusView.downLoadStatus = content.status
        statusView.id = content.contentID
    }
    
    private func switchMBForKB(capacity: Int64) -> String? {
        let multiflire: Double = 1000000
        let result = Double(capacity) / multiflire
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        let resultString = formatter.string(from: result as NSNumber)
        return resultString
    }
    
    
    @objc private func didTapStatusView(_ sender: SaveContentStatusView) {
        delegate?.saveContentControl(status: sender.downLoadStatus, id: sender.id)
    }
    
    @objc private func didTapThumbnailView(_ sender: UIButton) {
        delegate?.presentVideonController(contentID: statusView.id)
    }
        
}


