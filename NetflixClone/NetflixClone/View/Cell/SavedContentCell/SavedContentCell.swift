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
    func saveContentControl(content: SaveContent)
    func presentVideonController(content: SaveContent)
    func deleteSavedContent(content: SaveContent)
    func beganSwipeCell(content: SaveContent)
    func endedSwipeCell(content: SaveContent, isEditing: Bool)
//    func shouldBeganSwipeCell(indexPath: IndexPath)
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
    
    private var saveContent: SaveContent
    
    private var isEditingMode = false
    
//    private var indexPath = IndexPath(row: 0, section: 0)
    
    private var lastGestureX: CGFloat = 0
    
    private let mainContentView = UIView()
    
    private let deleteButton = UIButton()
    
    private let thumbnailImageView = UIImageView()
    private let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
    private let playImageBackgroundView = CircleView()
    private let playButton = UIButton()
    private let progressView = UIProgressView()
    
    private let summaryLabel = UILabel()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusView: SaveContentStatusView
    
    
    init(id: Int, saveContent: SaveContent, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.statusView = SaveContentStatusView(id: id, status: .saved)
        self.saveContent = saveContent
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
        
        [mainContentView, deleteButton, summaryLabel].forEach({
            contentView.addSubview($0)
        })
        
        [ thumbnailImageView, playButton, titleLabel, descriptionLabel, statusView].forEach({
            mainContentView.addSubview($0)
        })
        
        
//        let sizeGuide = UIScreen.main.bounds.height / 7
        
        selectionStyle = .none
        
        [playImageBackgroundView, progressView].forEach({
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
        summaryLabel.numberOfLines = 4
        
        statusView.addTarget(self, action: #selector(didTapStatusView(_:)), for: .touchUpInside)
        
        progressView.progressTintColor = .setNetfilxColor(name: .netflixRed)
        progressView.tintColor = .setNetfilxColor(name: .netflixLightGray)
    }
    
    private func setConstraint() {
        let xMargin = CGFloat.dynamicXMargin(margin: 16)
        let yMargin = CGFloat.dynamicYMargin(margin: 4)
        
        let xPading = CGFloat.dynamicXMargin(margin: 8)
        
        mainContentView.snp.makeConstraints({
            $0.width.equalToSuperview()
//            $0.top.bottom.equalToSuperview().inset(yMargin)
            $0.top.equalToSuperview().inset(yMargin)
        })
        
        deleteButton.snp.makeConstraints({
            $0.leading.equalTo(mainContentView.snp.trailing)
            $0.top.bottom.equalTo(thumbnailImageView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(0)
        })
        
        
        thumbnailImageView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(xMargin)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.6)
        })
//        thumbnailImageView.backgroundColor = .blue
        
        progressView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.top.equalTo(mainContentView.snp.bottom).offset(yMargin)
            $0.bottom.equalToSuperview().inset(yMargin)
        })
        
        
    }
    
    
    //MARK: Action
    
    func configure(content: SaveContent, isEditingMode: Bool) {
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        thumbnailImageView.kf.setImage(with: content.imageURL)
        summaryLabel.text = content.isSelected ? content.summary: ""
        statusView.downLoadStatus = content.status
        statusView.id = content.contentID
        setEditingMode(isEditing: content.isEditing)
        self.isEditingMode = isEditingMode
        self.saveContent = content
        configureProgress(content: content)
    }
    
    private func configureProgress(content: SaveContent) {
        if let range = content.contentRange, let savePoint = content.savePoint {
            progressView.isHidden = false
            let value = Float(savePoint) / Float(range)
            progressView.setProgress(value, animated: true)
        } else {
            progressView.isHidden = true
        }
    }
    
    func setEditingMode(isEditing: Bool) {
        
        let multiplier = isEditing && statusView.downLoadStatus == .saved ? 1: 0
        deleteButton.snp.remakeConstraints({
            $0.leading.equalTo(mainContentView.snp.trailing)
            $0.top.bottom.equalTo(mainContentView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(deleteButton.snp.height).multipliedBy(multiplier)
        })
        isEditingMode = isEditing
        print(#function, isEditing)
//        print(#function, deleteButton.frame)
    }
    
    func visibleCellEditingMode() {
        setEditingMode(isEditing: saveContent.isEditing)
    }
    
    @objc private func didTapStatusView(_ sender: SaveContentStatusView) {
        delegate?.saveContentControl(content: saveContent)
    }
    
    @objc private func didPlayButton(_ sender: UIButton) {
        delegate?.presentVideonController(content: saveContent)
    }
    
    @objc private func didTapDeleteButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
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
                self.delegate?.deleteSavedContent(content: self.saveContent)
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
        
        guard statusView.downLoadStatus == .saved else { return }
        
        let point = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            delegate?.beganSwipeCell(content: saveContent)
            print(#function, deleteButton.frame)
            break
        case .ended:
            endedGesture()
        case .changed:
            let x = point.x
            remakeConstraintsForGesture(x: x)
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
        print("before update constraints", deleteButton.frame)
        let result = deleteButton.bounds.width + (lastGestureX - x)
        print("x:", x)
        print("result", result)
        
        
        guard result >= 0 else { return }
        deleteButton.snp.remakeConstraints({
            $0.leading.equalTo(self.mainContentView.snp.trailing)
            $0.top.bottom.equalTo(self.mainContentView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(result)
//            self.layoutIfNeeded()
        })
        lastGestureX = x
    }
    
    // gesture가 종료 되었을때 호출되는 함수
    private func endedGesture() {
        let isEditing = deleteButton.bounds.width >= deleteButton.bounds.height / 2
        UIView.animate(withDuration: 0.2, animations: {
            self.setEditingMode(isEditing: isEditing)
            self.layoutIfNeeded()
        }, completion: {
            _ in
            print(#function, self.deleteButton.frame)
        })
        lastGestureX = 0
        print(deleteButton.frame)
        delegate?.endedSwipeCell(content: saveContent, isEditing: isEditing)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print(#function, deleteButton.frame)
    }
        
}


extension SavedContentCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
//        guard !isEditingMode else { print("ㅁㄴㄹㅁㄴㄹㅁㄴㄹㅁㄴㄹ"); return false }
        
//        delegate?.shouldBeganSwipeCell(indexPath: indexPath)
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        let translation = panGesture.translation(in: mainContentView)
        if abs(translation.x) > abs(translation.y) {
            return true
        } else {
            print(#function, "==================================\(translation)")
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
