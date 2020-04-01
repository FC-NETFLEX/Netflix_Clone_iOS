//
//  FirstView.swift
//  NetFlexFrame
//
//  Created by MyMac on 2020/03/20.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class FirstView: UIView {
    
    let textLabel = UILabel()
    let descriptLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .black
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [textLabel, descriptLabel].forEach {
            $0.textColor = .white
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textLabel.text = "Netflex에 가입하고\n 싶으신가요?"
        textLabel.font = .dynamicFont(fontSize: 30  , weight: .bold)
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 2
        
        descriptLabel.text = "앱 내에서도 Netflex에 가입할 수\n 있습니다. 번거로우시겠지만, 앱을 통한\n 시청은 회원 가입 후 가능합니다."
        descriptLabel.font = .dynamicFont(fontSize: 20, weight: .regular)
        descriptLabel.textAlignment = .center
        descriptLabel.lineBreakMode = .byWordWrapping
        descriptLabel.numberOfLines = 3
    }
    
    private func setConstraints() {
        let gapOfLabel = CGFloat.dinamicYMargin(margin: 25)
                
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            descriptLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: gapOfLabel),
            descriptLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
        ])
    }
    
}
