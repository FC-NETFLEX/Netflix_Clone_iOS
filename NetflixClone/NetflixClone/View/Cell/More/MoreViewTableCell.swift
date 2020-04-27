//
//  MoreViewTableCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol MoreViewTableCellDelegate: class {
    func didTapMoreTapButton(cell: MoreViewTableCell)
    
}

class MoreViewTableCell: UITableViewCell {
   
    weak var delegate: MoreViewTableCellDelegate?
    static let identifier = "MoreViewTableCell"
 
    private let selectImage = UIImageView()
    private let moreTapButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [selectImage,moreTapButton].forEach {
            addSubview($0)
        }
        selectImage.image = UIImage(named: "들어가기")
        selectImage.contentMode = .scaleAspectFill
        
        moreTapButton.backgroundColor = .clear
        moreTapButton.addTarget(self, action: #selector(didTapMoreTapButton), for: .touchUpInside)
     
        
    }
    func setConstraints() {
        let margin: CGFloat = 10
        
        selectImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin * 2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.03)
        }
        
        moreTapButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    @objc private func didTapMoreTapButton() {
        delegate?.didTapMoreTapButton(cell: self)
        
    }
    
}
