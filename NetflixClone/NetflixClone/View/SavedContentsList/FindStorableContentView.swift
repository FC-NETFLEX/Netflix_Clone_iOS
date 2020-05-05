//
//  FindCanSaveContentView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class FindStorableContentView: UIView {
    
    let tableView = UITableView()

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
        backgroundColor = .setNetfilxColor(name: .black)
        
        self.addSubview(tableView)
        tableView.backgroundColor = .setNetfilxColor(name: .black)
        tableView.separatorStyle = .none
        tableView.register(FindStorableContentTableViewCell.self, forCellReuseIdentifier: FindStorableContentTableViewCell.identifier)
        
        tableView.allowsSelection = false
        
    }
    
    private func setConstraint() {
        let guide = safeAreaLayoutGuide
        tableView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalTo(guide)
        })
    }

}
