//
//  ButtonsTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

protocol IsClickedProtocol: class {
    func dibButtonIsCliked()
    func likeButtonIsCliked()
}

protocol SaveStatusContentControl: class {
    func control(status: SaveContentStatus)
}

import UIKit

class ButtonsTableViewCell: UITableViewCell {
    
    static let identifier = "ButtonCell"
    
    private var isLike = false
    
    private let dibsView = CustomButtonView(imageName: "plus", labelText: "내가 찜한 콘텐츠")
    private let likeView = CustomButtonView(imageName: "hand.thumbsup", labelText: "평가")
    private let saveView = UIView()
    
    private let statusButton: SaveContentStatusView
    private let statusLabel = UILabel()
    
    private let redView = UIView()
    
    weak var delegate: IsClickedProtocol?
    weak var saveControl: SaveStatusContentControl?
    
    init(id: Int, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.statusButton = SaveContentStatusView(id: id, status: .doseNotSave)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUI()
        setConstraints()
        setStatusView(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [dibsView, likeView].forEach {
            self.addSubview($0)
            $0.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        
        [saveView].forEach({
            self.addSubview($0)
        })
        
        [statusButton, statusLabel].forEach({
            saveView.addSubview($0)
        })
        
        self.addSubview(redView)
        redView.backgroundColor = UIColor.setNetfilxColor(name: .netflixRed)
        
        statusLabel.text = statusButton.downLoadStatus.getSign()
        statusLabel.textColor = .setNetfilxColor(name: .white)
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.dynamicFont(fontSize: 8, weight: .regular)
        
        dibsView.button.tag = 0
        likeView.button.tag = 1
        
        statusButton.delegate = self
        statusButton.addTarget(self, action: #selector(didTapSaveButton(sender:)), for: .touchUpInside)
    }
    
    private func setStatusView(id: Int) {
        guard let saveContent = SavedContentsListModel.shared.getContent(contentID: id) else { return }
        statusButton.downLoadStatus = saveContent.status
    }
    
    @objc private func didTapSaveButton(sender: SaveContentStatusView) {
        print(#function)
        saveControl?.control(status: sender.downLoadStatus)
    }
    
    // MARK: 상세화면에서 '내가찜한콘텐츠', '평가', '저장' 버튼 눌렀을 때 액션
    @objc private func didTapButton(_ sender: UIButton) {
            var dibsButtonClicked = dibsView.isClicked
            var likeButtonClicked = likeView.isClicked
//            var saveButtonClicked = saveView.isClicked

        switch sender.tag {
        case 0:
            // MARK: 찜하기 버튼 눌렀을 때 액션, 서버로 보내기
            if dibsButtonClicked {
                print("찜하기 버튼 클릭: ", dibsButtonClicked)
                // MARK: 눌렀을 때 애니메이션 (숫자의 크기에 따라서 도는 방향이 결정 됨)
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "checkmark")})

            } else {
                print("찜하기 버튼 풀기: ", dibsButtonClicked)
                // MARK: 찜하기 버튼 한번 더 눌러서 액션 풀기, 서버로 보내기
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi / 2)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "plus")
                })
            }
            delegate?.dibButtonIsCliked()
            dibsButtonClicked.toggle()

        case 1:
            let duration = 0.4
            let relativeDuration = 0.2
            if likeButtonClicked {
                print("평가버튼 클릭: ", likeButtonClicked)
                UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {

                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: relativeDuration, animations: {
                        self.likeView.imageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                        self.likeView.imageView.image = UIImage(systemName: "hand.thumbsup.fill")
                    })
                    UIView.addKeyframe(withRelativeStartTime: relativeDuration, relativeDuration: relativeDuration, animations: {
                        self.likeView.imageView.transform = .identity
                    })
                })
            } else {
                print("평가버튼 풀기: ", likeButtonClicked)
                UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {

                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: relativeDuration, animations: {
                        self.likeView.imageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                        self.likeView.imageView.image = UIImage(systemName: "hand.thumbsup")
                    })
                    UIView.addKeyframe(withRelativeStartTime: relativeDuration, relativeDuration: relativeDuration, animations: {
                        self.likeView.imageView.transform = .identity
                    })
                })
            }
            delegate?.likeButtonIsCliked()
            likeButtonClicked.toggle()

//        case 2:
            // MARK: 와이파이 상태와 설정 값에 따라서 다운받기, 안받기 설정해야함
//            if saveButtonClicked {
//                print("저장버튼 클릭: ", saveButtonClicked)
//            } else {
//                print("저장버튼 풀기: ", saveButtonClicked)
//            }
//            saveButtonClicked.toggle()
        default:
            break
        }
    }
    
    private func setConstraints() {
        
        let customViewWidthMultiplying = 0.25
        let constant10 = CGFloat.dynamicXMargin(margin: 10)
        let redViewHeight = CGFloat.dynamicYMargin(margin: 5)
        let statusViewMultiplying = 0.3
        let constant5 = CGFloat.dynamicYMargin(margin: 5)
        
        dibsView.snp.makeConstraints {
            $0.width.equalTo(self.snp.width).multipliedBy(customViewWidthMultiplying)
            $0.height.equalTo(self.snp.height)
            $0.leading.equalTo(self.snp.leading)
            $0.top.equalTo(self.snp.top)
        }
        
        likeView.snp.makeConstraints {
            $0.width.equalTo(self.snp.width).multipliedBy(customViewWidthMultiplying)
            $0.height.equalTo(self.snp.height)
            $0.leading.equalTo(dibsView.snp.trailing)
            $0.top.equalTo(self.snp.top)
        }
        
        saveView.snp.makeConstraints {
            $0.width.equalTo(self.snp.width).multipliedBy(customViewWidthMultiplying)
            $0.height.equalTo(self.snp.height)
            $0.trailing.equalTo(self.snp.trailing)
            $0.top.equalTo(self.snp.top)
        }
        
        redView.snp.makeConstraints {
            $0.leading.equalTo(dibsView.snp.leading).offset(constant10)
            $0.bottom.equalTo(dibsView.snp.bottom)
            $0.trailing.equalTo(dibsView.snp.trailing)
            $0.height.equalTo(redViewHeight)
        }
        
        statusButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(saveView.snp.width).multipliedBy(statusViewMultiplying)
            $0.top.equalToSuperview().offset(constant5)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerX.equalTo(statusButton.snp.centerX)
            $0.top.equalTo(statusButton.snp.bottom).offset(constant5)
        }
        
    }
    
    func configure(dibsButtonClicked: Bool, likeButtonClicked: Bool) {
        dibsView.isClicked = dibsButtonClicked
        likeView.isClicked = likeButtonClicked
        dibsView.imageView.image = dibsButtonClicked ? UIImage(systemName: "checkmark"): UIImage(systemName: "plus")
        likeView.imageView.image = likeButtonClicked ? UIImage(systemName: "hand.thumbsup.fill"): UIImage(systemName: "hand.thumbsup")
    }
    
}


extension ButtonsTableViewCell: SaveContentStatusViewDelegate {
    func changeStatus(status: SaveContentStatus) {
        statusLabel.text = status.getSign()
    }
     
}
