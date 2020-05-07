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
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
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
    
//    func configure(title: String, imageURL: String) {
//        self.title = title
//        setPosterImage(imageURLString: imageURL)
//    }
    
    func setPosterImage(imageURLString: String) {
        guard let url = URL.safetyURL(string: imageURLString) else { return }
        KingfisherManager.shared.retrieveImage(with: url, completionHandler: {
            [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let imageResult):
                self?.posterImageView.image = imageResult.image
                self?.title = nil
            }
        })
    }
    
}
