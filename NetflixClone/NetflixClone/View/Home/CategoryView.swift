//
//  CategoryView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class CategoryView: UIView {
//    let categoryNum: Int

    let tableView = UITableView()
    
    //MARK: initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    private func setUI() {
        
        tableView.backgroundColor = .clear
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    
    
    
}
