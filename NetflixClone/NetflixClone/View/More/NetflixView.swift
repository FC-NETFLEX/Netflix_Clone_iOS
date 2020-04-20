//
//  NetflixView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class NetflixView: UIView {
    
    let giftImage = UIImageView()
    let netflixLabel = UILabel()
    let directlyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        netflixLabel.text = "dijdfj"
        addSubview(netflixLabel)
        
    }
    func setConstraints() {
        
    }

  
}
