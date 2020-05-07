//
//  UsingDataGraphCellTableViewCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class UsingDataGraphCellTableViewCell: UITableViewCell {
    
    static let identifier = "UsingDataGraphCellTableViewCell"
    let graphView = UsingDataView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        addSubview(graphView)
        selectionStyle = .none
    }
    func setConstraints() {
        graphView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            
        }
    }
    func setConfigure() {
        graphView.updateNetflixDataConstraints()
    }
}


