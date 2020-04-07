//
//  ButtonsTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {
    
    static let identifier = "ButtonCell"
    
    private let dibsView = CustomButtonView(imageName: "plus", labelText: "내가 찜한 콘텐츠")
    private let likeView = CustomButtonView(imageName: "hand.thumbsup", labelText: "평가")
    private let saveView = CustomButtonView(imageName: "arrow.down.to.line", labelText: "저장")
    private let redView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [dibsView, likeView, saveView].forEach {
            self.addSubview($0)
            $0.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        self.addSubview(redView)
        redView.backgroundColor = UIColor.setNetfilxColor(name: .netflixRed)
        
        dibsView.button.tag = 0
        likeView.button.tag = 1
        saveView.button.tag = 2
    }
    
    // MARK: 상세화면에서 '내가찜한콘텐츠', '평가', '저장' 버튼 눌렀을 때 액션
    @objc private func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // MARK: 찜하기 버튼 눌렀을 때 액션, 서버로 보내기
            if dibsView.isClicked {
                print("찜하기 버튼 클릭")
                // MARK: 눌렀을 때 애니메이션 (숫자의 크기에 따라서 도는 방향이 결정 됨)
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "checkmark")})
                
            } else {
                print("찜하기 버튼 풀기")
                // MARK: 찜하기 버튼 한번 더 눌러서 액션 풀기, 서버로 보내기
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi / 2)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "plus")
                })
            }
            dibsView.isClicked.toggle()
            
        case 1:
            let duration = 0.4
            let relativeDuration = 0.2
            if likeView.isClicked {
                print("평가버튼 클릭")
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
                print("평가버튼 풀기")
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
            likeView.isClicked.toggle()
            
        case 2:
            // MARK: 와이파이 상태와 설정 값에 따라서 다운받기, 안받기 설정해야함
            if saveView.isClicked {
                print("저장버튼 클릭")
            } else {
                print("저장버튼 풀기")
            }
            saveView.isClicked.toggle()
        default:
            break
        }
    }
    
    private func setConstraints() {
        
        let customViewWidthMultiplying = 0.25
        let constant10 = CGFloat.dynamicXMargin(margin: 10)
        let redViewHeight = CGFloat.dynamicYMargin(margin: 5)
        
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
    }
}
