//
//  MobileDataTableViewCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/18.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
protocol MobileDataTableViewCellDelegate: class {
    func autoSwitchIsOn(autoSwitch: UISwitch, cell: MobileDataTableViewCell)
}

class MobileDataTableViewCell: UITableViewCell {
    
    static let identifier = "MobileDataTableViewCell"
    var delegate: MobileDataTableViewCellDelegate?
    let autoSwitch = UISwitch()
    let checkImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [autoSwitch].forEach {
            addSubview($0)
        }
        autoSwitch.onTintColor = #colorLiteral(red: 0.0431372549, green: 0.4392156863, blue: 0.9411764706, alpha: 1)
        autoSwitch.tintColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        autoSwitch.addTarget(self, action: #selector(autoSwitchIsOn), for: .touchUpInside)
        
        
    }
    private func setConstraints() {
        let margin: CGFloat = 10
        let padding: CGFloat = 30
        
        autoSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin * 2)
            $0.centerY.equalToSuperview()
        }
        
    }
    func mobileCellConfigure(indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            accessoryType = .none
            break
        case 1:
//            accessoryType = .checkmark
            autoSwitch.isHidden = true
        case 2:
//            accessoryType = .checkmark
            autoSwitch.isHidden = true
        case 3:
//            accessoryType = .checkmark
            autoSwitch.isHidden = true
            
        default:
            //            accessoryType = .none
            autoSwitch.isHidden = true
            
        }
    }
    @objc private func autoSwitchIsOn() {
 
        delegate?.autoSwitchIsOn(autoSwitch: autoSwitch, cell: self)
    }
}
