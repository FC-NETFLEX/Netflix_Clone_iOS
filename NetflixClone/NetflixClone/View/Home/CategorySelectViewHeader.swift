//
//  CategoryViewHeader.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
protocol CategoryHeaderDelegate: class {
    func didTabView() -> ()
}
class CategorySelectViewHeader: UIView {
    
    weak var delegate: CategoryHeaderDelegate?
    
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        title.text = "전체 장르"
        title.font = .systemFont(ofSize: 18)
        title.textColor = .white
        title.textAlignment = .center
        title.backgroundColor = .clear
        
        addSubview(title)
        
        title.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.didTabView()
        
    }
}
