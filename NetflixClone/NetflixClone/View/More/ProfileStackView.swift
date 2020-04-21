//
//  ProfileStackView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/19.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class ProfileStackView: UIStackView {
   
    let profileArray = [ProfileView]()
    
    private let userView0 = MorePofileView()
    private let userView1 = MorePofileView()
    private let userView2 = MorePofileView()
    private let userView3 = MorePofileView()
    private let userView4 = MorePofileView()
    private let addUserView = AddProfileButtonView()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUI()
        setConstraints()
        print("스택뷰")
        print("프로필갯수",profileArray.count)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
    
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
//        self.spacing = 0
        

    
        
        [userView0,userView1,userView2,userView3,userView4,addUserView].forEach {
            addArrangedSubview($0)
        }

    }
    func setConstraints() {
    
    
        
       
    }
}
