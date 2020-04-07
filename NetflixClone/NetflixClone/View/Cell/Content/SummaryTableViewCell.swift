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
    
        summaryTextView.numberOfLines = 0
        summaryTextView.backgroundColor = .clear
        summaryTextView.textColor = UIColor.setNetfilxColor(name: .white)
        summaryTextView.font = UIFont.dynamicFont(fontSize: 13.8, weight: .regular)
        
        // MARK: 서버로부터 응답 받은 텍스트
        summaryTextView.text = """
        도쿄의 잘생긴 남자로 살아볼 순 없을까? 따분한 시골 생활에 질려 도시를 동경하는 여고생. 어느날, 그 소원이 실제로 이루어진다. 도쿄의 남고생과 이따금 몸이 뒤바뀌는 것. 꿈결 같은 둘의 인연은 또 다른 운명을 부르기 시작한다.
        """
    }
    
    private func setConstraints() {
        let constant10 = 10
        let constant5 = 5
        summaryTextView.snp.makeConstraints {
            $0.top.bottom.equalTo(self).inset(constant5)
            $0.leading.trailing.equalTo(self).inset(constant10)
        }
    }
    
}
