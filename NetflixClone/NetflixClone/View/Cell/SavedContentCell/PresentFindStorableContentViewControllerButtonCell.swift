//
//  PresentFindCanSaveContentViewControllerButtonCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class PresentFindStorableContentViewControllerButtonCell: UITableViewCell {
    
    static let identifier = "PresentFindCanSaveContentViewControllerButtonCell"
    
    weak var delegate: SavedContentsListViewDelegate?
    private let button = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        selectionStyle = .none
        
        contentView.addSubview(button)
        
        
        
        let inset = CGFloat.dynamicYMargin(margin: 8)
        button.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.tintColor = .setNetfilxColor(name: .white)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.setNetfilxColor(name: .netflixLightGray).cgColor
        button.setTitle(" 저장 가능한 콘텐츠 더 찾아보기 ", for: .normal)
        button.titleLabel?.font = .dynamicFont(fontSize: 14, weight: .regular)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    private func setConstraint() {
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(CGFloat.dynamicYMargin(margin: 32))
        })
    }
    
    @objc private func didTapButton() {
        delegate?.findStorableContent()
    }
    
}
