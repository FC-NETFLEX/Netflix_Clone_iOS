//
//  CategoryView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    let categoryNum: Int

    let tableView = UITableView()
    
    //MARK: initializer
    init(frame: CGRect, categoryNum: Int) {
        self.categoryNum = categoryNum
        super.init(frame: frame)
        
        backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        setUI()
        
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
