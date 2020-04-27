//
//  SummaryTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    static let identifier = "SummaryCell"
    
    let summaryTextView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [summaryTextView].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .clear
    
        summaryTextView.numberOfLines = 5
        summaryTextView.backgroundColor = .clear
        summaryTextView.textColor = UIColor.setNetfilxColor(name: .white)
        summaryTextView.font = UIFont.dynamicFont(fontSize: 13.8, weight: .regular)
        
        // MARK: 서버로부터 응답 받은 텍스트 => Fixed
    }
    
    private func setConstraints() {
        let constant10 = 10
        let constant5 = 5
        summaryTextView.snp.makeConstraints {
            $0.top.bottom.equalTo(self).inset(constant5)
            $0.leading.trailing.equalTo(self).inset(constant10)
        }
    }
    
    func configure(summary: String) {
        self.summaryTextView.text = summary
    }
    
}
