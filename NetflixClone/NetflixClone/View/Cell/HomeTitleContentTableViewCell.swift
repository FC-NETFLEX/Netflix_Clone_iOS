//
//  HomeTitleContentTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class HomeTitleContentTableViewCell: UITableViewCell {
    
    let identifier = "HomeTitleContentCell"
    
    private let titleImage = UIImageView()
//    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dibsButton = UIButton()
    private let playButton = UIButton()
    private let inforButton = UIButton()
    
//    private var title: String
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - UI
    private func setUI() {
        
    }
    
    private func setConstraints() {
        
    }
    
    
    // MARK: - configure
    func configure(poster: UIImage, title: String, category: [String], dibs: Bool) {
        self.title = title
    }
    
    //MARK: - action
    @objc private func didTabdibsButton(sender: UIButton) {
        
    }
    
    @objc private func didTabPlayButton(sender: UIButton) {
        
    }
    
    @objc private func didTabInformation(sender: UIButton) {
        
    }
}
