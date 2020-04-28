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
    func deleteSavedContent(contentID: Int)
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
    
    private var lastGestureX: CGFloat = 0
    
    private let mainContentView = UIView()
    
    private let deleteButton = UIButton()
    
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
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .black)
        
        [mainContentView, deleteButton].forEach({
            contentView.addSubview($0)
        })
        
        [summaryLabel, thumbnailImageView, playButton, titleLabel, descriptionLabel, statusView].forEach({
            mainContentView.addSubview($0)
        })
        
        
//        let sizeGuide = UIScreen.main.bounds.height / 7
        
        selectionStyle = .none
        
        [playImageBackgroundView].forEach({
            thumbnailImageView.addSubview($0)
        })
        
        deleteButton.backgroundColor = .setNetfilxColor(name: .netflixRed)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .setNetfilxColor(name: .white)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        
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
        
        mainContentView.snp.makeConstraints({
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(yMargin)
        })
        
        deleteButton.snp.makeConstraints({
            $0.leading.equalTo(mainContentView.snp.trailing)
            $0.top.bottom.equalTo(mainContentView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(0)
        })
        
        
        thumbnailImageView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
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
    func configure(content: SaveContent, isEditing: Bool) {
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        thumbnailImageView.kf.setImage(with: content.imageURL)
        summaryLabel.text = content.isSelected ? content.summary: ""
        statusView.downLoadStatus = content.status
        statusView.id = content.contentID
        setEditingMode(isEditing: isEditing)
    }
    
    func setEditingMode(isEditing: Bool) {
        
        let multiplier = isEditing ? 1: 0
        deleteButton.snp.remakeConstraints({
            $0.leading.equalTo(mainContentView.snp.trailing)
            $0.top.bottom.equalTo(mainContentView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(deleteButton.snp.height).multipliedBy(multiplier)
        })
    }
    
    
    @objc private func didTapStatusView(_ sender: SaveContentStatusView) {
        delegate?.saveContentControl(status: sender.downLoadStatus, id: sender.id)
    }
    
    @objc private func didPlayButton(_ sender: UIButton) {
        delegate?.presentVideonController(contentID: statusView.id)
    }
    
    @objc private func didTapDeleteButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.deleteButton.snp.remakeConstraints({
                $0.leading.equalTo(self.mainContentView.snp.trailing)
                $0.top.bottom.equalTo(self.mainContentView)
                $0.trailing.equalToSuperview()
                $0.width.equalTo(self.mainContentView.snp.width)
            })
            self.layoutIfNeeded()
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.deleteSavedContent(contentID: self.statusView.id)
        })
    }
    
    // panGesture 등록
    private func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        mainContentView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    // panGesture의 동작 메서드
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        
        let point = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            print("PanGesture Began")
            break
        case .ended:
            endedGesture()
        case .changed:
            let x = point.x
            remakeConstraintsForGesture(x: x)
            lastGestureX = x
        default:
            break
        }
        
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print(#function, point)
//        return super.hitTest(point, with: event)
//    }
    
    
    // gesture에 따른 constraint 업데이트
    private func remakeConstraintsForGesture(x: CGFloat) {
        let result = deleteButton.bounds.width + (lastGestureX - x)
        guard result >= 0 else { return }
        deleteButton.snp.remakeConstraints({
            $0.leading.equalTo(self.mainContentView.snp.trailing)
            $0.top.bottom.equalTo(self.mainContentView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(result)
        })
    }
    
    // gesture가 종료 되었을때 호출되는 함수
    private func endedGesture() {
        let isEditing = deleteButton.bounds.width >= deleteButton.bounds.height / 2
        UIView.animate(withDuration: 0.2, animations: {
            self.setEditingMode(isEditing: isEditing)
            self.layoutIfNeeded()
        })
        lastGestureX = 0
    }
    
        
}


extension SavedContentCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        let translation = panGesture.translation(in: mainContentView)
        print(translation)
        if abs(translation.x) > abs(translation.y) {
            return true
        } else {
            return false
        }
    }
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
//            let translation = panGestureRecognizer.translationInView(mainContentView)
//            if fabs(translation.x) > fabs(translation.y) {
//                return true
//            }
//            return false
//        }
//        return false
//    }
}
