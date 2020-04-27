//
//  FindStorableCollectionViewCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import Kingfisher

class FindStorableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FindStorableCollectionViewCell"
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    private let titleLabel = UILabel()
    private let posterImageView = UIImageView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI() {
        [titleLabel, posterImageView].forEach({
            contentView.addSubview($0)
        })
        
        titleLabel.textColor = .setNetfilxColor(name: .white)
        posterImageView.contentMode = .scaleAspectFit
        
    }
    
    private func setConstraint() {
        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalTo(posterImageView)
            $0.centerY.equalToSuperview()
        })
        
        posterImageView.snp.makeConstraints({
            $0.leading.top.trailing.bottom.equalToSuperview()
        })
    }
    
    //MARK: Action
    
    func setPosterImage(imageURLString: String) {
        let url = URL.safetyURL(string: imageURLString)
        posterImageView.kf.setImage(with: url)
        titleLabel.text = nil
    }
    
}
