//
//  AddProfileView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol AddProfileViewDelegate: class {
    func newProfileButtonDidTap()
    func kidsSwitchDidTap()
}


class AddProfileView: UIView {
    
    private let newProfileButton = UIButton()
    private let changeLabel = UILabel()
    let nickNameTextfield = UITextField()
    private let kidsLabel = UILabel()
    let kidsSwitch = UISwitch()
    
    weak var delegate: AddProfileViewDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        let cornerRadius: CGFloat = 4
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        [newProfileButton,changeLabel,nickNameTextfield,kidsLabel,kidsSwitch].forEach {
            self.addSubview($0)
        }
        
        newProfileButton.setImage(UIImage(named: "프로필3"), for: .normal)
        newProfileButton.contentMode = .scaleAspectFill
        newProfileButton.imageView?.layer.masksToBounds = true
        newProfileButton.imageView?.layer.cornerRadius = cornerRadius
        newProfileButton.addTarget(self, action: #selector(newProfileButtonDidTap), for: .touchUpInside)
        
        changeLabel.text = "변경"
        changeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        changeLabel.font = UIFont.systemFont(ofSize: 17)
        
        nickNameTextfield.addLeftPadding()
        nickNameTextfield.layer.borderWidth = 1
        nickNameTextfield.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nickNameTextfield.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nickNameTextfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        kidsLabel.text = "키즈용"
        kidsLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        kidsLabel.font = UIFont.systemFont(ofSize: 17)
        
        kidsSwitch.onTintColor = #colorLiteral(red: 0.04303120111, green: 0.4391969315, blue: 0.9407585816, alpha: 1)
        kidsSwitch.tintColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        
        kidsSwitch.addTarget(self, action: #selector(kidsSwitchDidTap), for: .touchUpInside)
        
    }
    private func setConstraints() {
        
        let margin: CGFloat = 10
        let padding: CGFloat = 40
        let spacing: CGFloat = 50
        
        
        [newProfileButton,changeLabel,nickNameTextfield,kidsLabel,kidsSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        newProfileButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -spacing).isActive = true
        newProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newProfileButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        newProfileButton.heightAnchor.constraint(equalTo: newProfileButton.widthAnchor).isActive = true
        
        changeLabel.topAnchor.constraint(equalTo: newProfileButton.bottomAnchor, constant: margin).isActive = true
        changeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nickNameTextfield.topAnchor.constraint(equalTo: changeLabel.bottomAnchor, constant: margin * 2 ).isActive = true
        nickNameTextfield.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding * 2).isActive = true
        nickNameTextfield.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding * 2).isActive = true
        nickNameTextfield.heightAnchor.constraint(equalToConstant: padding * 1.1).isActive = true
        
        kidsSwitch.topAnchor.constraint(equalTo: nickNameTextfield.bottomAnchor, constant: margin * 2 ).isActive = true
        kidsSwitch.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: margin / 2).isActive = true
        
        kidsLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -(margin / 2)).isActive = true
        kidsLabel.centerYAnchor.constraint(equalTo: kidsSwitch.centerYAnchor).isActive = true
        
        
    }
    @objc private func newProfileButtonDidTap() {
        delegate?.newProfileButtonDidTap()
        
    }
    @objc private func kidsSwitchDidTap() {
        if kidsSwitch.isOn == true {
            return
        } else {
            delegate?.kidsSwitchDidTap()
        }
    }
    
}
extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addleftimage(image:UIImage) {
        let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        leftimage.image = image
        self.leftView = leftimage
        self.leftViewMode = .always
    }
}

  
  
    


