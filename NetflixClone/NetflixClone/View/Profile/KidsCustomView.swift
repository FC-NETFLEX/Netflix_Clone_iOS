//
//  KidsCustomView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/01.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol KidsCustomViewDelegate: class {
    func kidsSwitchDidTap()
}

class KidsCustomView: UIView {
    
    private let kidsLabel = UILabel()
    let kidsSwitch = UISwitch()
    
    weak var delegate: KidsCustomViewDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        [kidsLabel,kidsSwitch].forEach {
            self.addSubview($0)
        }
        
        kidsLabel.text = "키즈용"
        kidsLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        kidsLabel.font = UIFont.dynamicFont(fontSize: 17, weight: .regular)
        
        kidsSwitch.onTintColor = #colorLiteral(red: 0.04303120111, green: 0.4391969315, blue: 0.9407585816, alpha: 1)
        kidsSwitch.tintColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        
        kidsSwitch.addTarget(self, action: #selector(kidsSwitchDidTap), for: .touchUpInside)
        
    }
    private func setConstraints() {
        
        let margin: CGFloat = 10
        
        [kidsLabel,kidsSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        kidsSwitch.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: margin / 2).isActive = true
        
        kidsLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -(margin / 2)).isActive = true
        kidsLabel.centerYAnchor.constraint(equalTo: kidsSwitch.centerYAnchor).isActive = true
        
        
    }
    
    @objc private func kidsSwitchDidTap() {
        if kidsSwitch.isOn == true {
            return
        } else {
            delegate?.kidsSwitchDidTap()
        }
    }
    
}


