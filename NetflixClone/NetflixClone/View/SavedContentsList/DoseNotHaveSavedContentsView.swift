//
//  DoseNotHaveSavedContentsView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class DoseNotHaveSavedContentsView: UIView {
    
    weak var delegate: SavedContentsListViewDelegate?
    
    private let imageViewsBackground = CircleView()
    private let imageView = UIImageView()
    private let commentLabel = UILabel()
    private let findStorableContentButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI() {
        backgroundColor = .setNetfilxColor(name: .backgroundGray)
        
        [imageViewsBackground, commentLabel, findStorableContentButton].forEach({
            addSubview($0)
        })
        
        [imageView].forEach({
            imageViewsBackground.addSubview($0)
        })
        
        imageViewsBackground.backgroundColor = .setNetfilxColor(name: .black)
        
        imageView.image = UIImage(systemName: "arrow.down.to.line.alt")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .setNetfilxColor(name: .netflixLightGray)
        
        commentLabel.textAlignment = .center
        commentLabel.textColor = .setNetfilxColor(name: .netflixLightGray)
        commentLabel.numberOfLines = 0
        commentLabel.attributedText = setAttributeComment()
        
        let buttonInset = CGFloat.dynamicXMargin(margin: 10)
        findStorableContentButton.contentEdgeInsets = UIEdgeInsets(top: buttonInset, left: buttonInset, bottom: buttonInset, right: buttonInset)
        findStorableContentButton.setTitle("저장 가능한 콘텐츠 찾아보기", for: .normal)
        findStorableContentButton.titleLabel?.font = .dynamicFont(fontSize: 16, weight: .regular)
        findStorableContentButton.tintColor = .setNetfilxColor(name: .white)
        findStorableContentButton.addTarget(self, action: #selector(didTapFindStorableContentButton(_:)), for: .touchUpInside)
        findStorableContentButton.layer.borderWidth = 1
        findStorableContentButton.layer.borderColor = UIColor.setNetfilxColor(name: .netflixDarkGray).cgColor
        
    }
    
    private func setConstraints() {
        let guide = safeAreaLayoutGuide
        let yMargin = CGFloat.dynamicYMargin(margin: 40)
        let xMargin = CGFloat.dynamicXMargin(margin: 40)
        
        imageViewsBackground.snp.makeConstraints({
            $0.centerY.equalTo(guide).multipliedBy(0.5)
            $0.centerX.equalTo(guide.snp.centerX)
            $0.width.height.equalTo(guide.snp.width).multipliedBy(0.4)
        })
        
        imageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.5)
        })
        
        commentLabel.snp.makeConstraints({
            $0.top.equalTo(imageViewsBackground.snp.bottom).offset(yMargin)
            $0.leading.trailing.equalTo(guide).inset(xMargin)
        })
        
        findStorableContentButton.snp.makeConstraints({
            $0.top.equalTo(commentLabel.snp.bottom).offset(yMargin)
            $0.centerX.equalTo(guide)
        })
        
    }
    
    private func setAttributeComment() -> NSMutableAttributedString {
        let comment = """
        언제 어디서나 Netflex와 함께하세요
        \n오프라인에서도 언제든지 시청할 수 있도록 TV 프로그램과 영화를 저장하세요.
        """
        
        let attributedComment = NSMutableAttributedString(string: comment)
        let commentFont = UIFont.dynamicFont(fontSize: 20, weight: .bold)
        let commentTextColor = UIColor.setNetfilxColor(name: .white)
        attributedComment.addAttributes(
            [NSAttributedString.Key.font: commentFont, NSAttributedString.Key.foregroundColor: commentTextColor],
            range: (comment as NSString).range(of: "언제 어디서나 Netflex와 함께하세요"))
        return attributedComment
    }
    
    //MARK: Action
    
    @objc private func didTapFindStorableContentButton(_ sender: UIButton) {
//        print(#function)
        delegate?.findStorableContent()
    }
    
}


