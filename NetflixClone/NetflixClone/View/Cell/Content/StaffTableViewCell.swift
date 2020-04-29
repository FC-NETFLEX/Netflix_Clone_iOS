//
//  StaffTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {
    
    static let identifier = "StaffCell"
    
    private let actor = UILabel()
    private let director = UILabel()
    private let actorLabel = UILabel()
    private let directorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [actor, director, actorLabel, directorLabel].forEach {
            self.addSubview($0)
            $0.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        self.backgroundColor = .clear
        actor.text = "출연: "
        director.text = "감독: "
        
        // MARK: 서버로부터 응답 받은 텍스트 => Fixed
    }
    
    private func setConstraints() {
        let constant10 = 10
        let textSpacing = 5
        actor.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).inset(textSpacing)
            $0.leading.equalTo(self.snp.leading).inset(constant10)
        }
        
        actorLabel.snp.makeConstraints {
            $0.top.equalTo(actor.snp.top)
            $0.leading.equalTo(actor.snp.trailing).offset(textSpacing)
        }

        director.snp.makeConstraints {
            $0.leading.equalTo(actor.snp.leading)
            $0.top.equalTo(actor.snp.bottom)
            $0.bottom.equalTo(self.snp.bottom).inset(textSpacing)
        }

        directorLabel.snp.makeConstraints {
            $0.top.equalTo(director.snp.top)
            $0.leading.equalTo(director.snp.trailing).offset(textSpacing)
            $0.bottom.equalTo(director.snp.bottom)
        }
    }
    
    func configure(actor: [String], director: [String]) {
        self.actorLabel.text = actor.joined(separator: ", ")
        self.directorLabel.text = director.joined(separator: ", ")
    }
    
}
