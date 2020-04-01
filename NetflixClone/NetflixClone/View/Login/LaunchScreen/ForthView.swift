//
//  FirstView.swift
//  NetFlexFrame
//
//  Created by MyMac on 2020/03/20.
//  Copyright © 2020 sandMan. All rights reserved.
//


import UIKit

class ForthView: UIView {
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
        
        centerImage.image = UIImage(named: "fireWork")
        centerImage.contentMode = .scaleAspectFit
        self.addSubview(centerImage)
        centerImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        textLabel.text = "약정도 광고도 없다."
        textLabel.font = .dynamicFont(fontSize: 30  , weight: .bold)
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 2
        
        descriptLabel.text = "멤버십은 언제든지 해지하실 수\n 있습니다."
        descriptLabel.font = .dynamicFont(fontSize: 20, weight: .regular)
        descriptLabel.textAlignment = .center
        descriptLabel.lineBreakMode = .byWordWrapping
        descriptLabel.numberOfLines = 3
    }
    
    private func setConstraints() {
        let gapOfLabel = CGFloat.dinamicYMargin(margin: 25)
        let imageBottom = CGFloat.dinamicYMargin(margin: 10)
        
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

