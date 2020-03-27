//
//  FirstView.swift
//  NetFlexFrame
//
//  Created by MyMac on 2020/03/20.
//  Copyright © 2020 sandMan. All rights reserved.
//


import UIKit

class ThirdView: UIView {
    let centerImage = UIImageView()
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
        
        centerImage.image = UIImage(named: "lunchedRoket")
        centerImage.contentMode = .scaleAspectFit
        self.addSubview(centerImage)
        centerImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        textLabel.text = "나가기전에\n 저장하세요!"
        textLabel.font = .dynamicFont(fontSize: 30  , weight: .bold)
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 2
        
        descriptLabel.text = "인터넷이 없어도 언제 어디서나\n 넷플릭스를! 잠수함에서도 즐겨보세요.\n 혹시 탈 일이 있다면."
        descriptLabel.font = .dynamicFont(fontSize: 20, weight: .regular)
        descriptLabel.textAlignment = .center
        descriptLabel.lineBreakMode = .byWordWrapping
        descriptLabel.numberOfLines = 3
    }
    
    private func setConstraints() {
        let gapOfLabel = CGFloat.dynamicYMargin(margin: 25)
        let imageBottom = CGFloat.dynamicYMargin(margin: 10)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            descriptLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: gapOfLabel),
            descriptLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            
            centerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: imageBottom),
            centerImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            centerImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33)
        ])
    }
    
}

