//
//  UsingDataView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class UsingDataView: UIView {
    let myDeviceLabel = UILabel()
    let usageGraphView = UIView()
    let nonUseGraphView = UIView()
    
    let device = UIDevice.current
    
    let usageView = SquareUsingView()
    let nonUseView = SquareUsingView()
    let netflixView = SquareUsingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [myDeviceLabel, usageGraphView, nonUseGraphView, usageView, nonUseView, netflixView].forEach {
            addSubview($0)
        }
        backgroundColor = .setNetfilxColor(name: .backgroundGray)
        
        myDeviceLabel.text = device.modelName
        myDeviceLabel.textColor = .gray
        myDeviceLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular)
        
        usageGraphView.backgroundColor = .darkGray
        
        nonUseGraphView.backgroundColor = .white
        
        usageView.usingLabel.text = "사용함"
        usageView.usingLabel.textAlignment = .left
        
        netflixView.usingLabel.text = "NetFlix"
        netflixView.usingLabel.textAlignment = .center
        netflixView.squareView.backgroundColor = #colorLiteral(red: 0.2057322158, green: 0.6013665585, blue: 0.8699436865, alpha: 1)
        
        nonUseView.usingLabel.text = "사용 안 함"
        nonUseView.usingLabel.textAlignment = .right
        nonUseView.squareView.backgroundColor = .white
        
        
        
    }
    private func setConstraints() {
        let guide = safeAreaLayoutGuide
        let padding: CGFloat = 20
        let margin: CGFloat = 10
        
        myDeviceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(padding)
            $0.bottom.equalTo(usageGraphView.snp.top).inset(-margin)
        }
        
        usageGraphView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.13)
        }
        
        nonUseGraphView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(padding)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.13)
        }
        
        usageView.snp.makeConstraints {
            $0.leading.equalTo(usageGraphView.snp.leading)
            $0.top.equalTo(usageGraphView.snp.bottom).inset(-margin)
            $0.height.equalToSuperview().multipliedBy(0.13)
            $0.width.equalTo(guide.snp.width).multipliedBy(0.15)
        }
        
        netflixView.snp.makeConstraints {
            $0.centerX.equalTo(guide.snp.centerX)
            $0.top.equalTo(usageView.snp.top)
            $0.height.equalToSuperview().multipliedBy(0.13)
            $0.width.equalTo(guide.snp.width).multipliedBy(0.15)
        }
        
        nonUseView.snp.makeConstraints {
            $0.trailing.equalTo(nonUseGraphView.snp.trailing)
            $0.top.equalTo(usageView.snp.top)
            $0.height.equalToSuperview().multipliedBy(0.13)
            $0.width.equalTo(guide.snp.width).multipliedBy(0.17)
        }
        
    }
    
    
    
}
