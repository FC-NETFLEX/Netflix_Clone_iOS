//
//  MoreView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class MoreView: UIView {
   
    let profileStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    let userView1: UIView = {
        let view = ProfileView()
        return view
    }()
    let userView2: UIView = {
        let view = ProfileView()
        return view
    }()
    let userView3: UIView = {
        let view = ProfileView()
        return view
    }()
    let userView4: UIView = {
        let view = ProfileView()
        return view
    }()
    let usetPlusButton: UIView = {
        let view = AddProfileButtonView()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        
    }
    
}
