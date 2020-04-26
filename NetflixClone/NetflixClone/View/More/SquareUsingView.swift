//
//  SquareUsingView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class SquareUsingView: UIView {
    
    let squareView = UIView()
    let usingLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [usingLabel,squareView].forEach {
            addSubview($0)
        }
        
        squareView.backgroundColor = .gray
        
        usingLabel.text = "Netflix"
        usingLabel.textColor = .gray
        usingLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular)
        
        
    }
    private func setConstraints() {
        let padding: CGFloat = 5
        
        squareView.snp.makeConstraints {
            $0.top.leading.height.equalToSuperview()
            $0.width.equalTo(squareView.snp.height)
            
        }
        usingLabel.snp.makeConstraints {
            $0.centerY.equalTo(squareView.snp.centerY)
            $0.leading.equalTo(squareView.snp.trailing).inset(-padding)
            
        }
    }
}
