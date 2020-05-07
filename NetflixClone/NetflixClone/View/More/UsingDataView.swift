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
    let unUsedGraphView = UIView()
    let netflixGraphView = UIView()
    
    let device = UIDevice.current
    
    let usageView = SquareUsingView()
    let unUsedView = SquareUsingView()
    let netflixView = SquareUsingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        print("넷플리스용량", netflixDataPercentage())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI() {
        [myDeviceLabel, usageGraphView, unUsedGraphView, netflixGraphView, usageView, unUsedView, netflixView].forEach {
            addSubview($0)
        }
        backgroundColor = .setNetfilxColor(name: .backgroundGray)
        
        myDeviceLabel.text = device.modelName
        myDeviceLabel.textColor = .gray
        myDeviceLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular)
        
        usageGraphView.backgroundColor = .darkGray
        
        unUsedGraphView.backgroundColor = .setNetfilxColor(name: .white)
        
        netflixGraphView.backgroundColor = #colorLiteral(red: 0.2057322158, green: 0.6013665585, blue: 0.8699436865, alpha: 1)
        
        usageView.usingLabel.text = "사용함"
        usageView.usingLabel.textAlignment = .left
        
        netflixView.usingLabel.text = "NetFlix"
        netflixView.usingLabel.textAlignment = .center
        netflixView.squareView.backgroundColor = #colorLiteral(red: 0.2057322158, green: 0.6013665585, blue: 0.8699436865, alpha: 1)
        
        unUsedView.usingLabel.text = "사용 안 함"
        unUsedView.usingLabel.textAlignment = .right
        unUsedView.squareView.backgroundColor = .white
        
        
        
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
        netflixGraphView.snp.makeConstraints {
            $0.trailing.equalTo(unUsedGraphView.snp.leading)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(usageGraphView.snp.height)
            $0.width.equalTo(usageGraphView.snp.width).multipliedBy(netflixDataPercentage())
        }
        
        unUsedGraphView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(padding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(usageGraphView.snp.height)
            $0.width.equalTo(usageGraphView.snp.width).multipliedBy(deviceDataPercentage())
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
        
        unUsedView.snp.makeConstraints {
            $0.trailing.equalTo(unUsedGraphView.snp.trailing)
            $0.top.equalTo(usageView.snp.top)
            $0.height.equalToSuperview().multipliedBy(0.13)
            $0.width.equalTo(guide.snp.width).multipliedBy(0.17)
        }
        
    }
    func deviceRemainingFreeSpaceInBytes() -> NSNumber { // 남은 데이터
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let systemAttributes = try! FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last! as String)
        return systemAttributes[FileAttributeKey.systemFreeSize] as! NSNumber
    }
    func deviceRemainingSpaceInBytes() -> NSNumber { // 전체 데이터
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let systemAttributes = try! FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last! as String)
        return systemAttributes[FileAttributeKey.systemSize] as! NSNumber
    }
    
    
    func deviceDataPercentage() -> Double {
        guard
            let totalData = deviceRemainingSpaceInBytes() as? Double,
            let unUsedData = deviceRemainingFreeSpaceInBytes() as? Double
            else { return 0 }
        
        return (floor((unUsedData / totalData) * 1000)) / 1000

    }
    func netflixDataPercentage() -> Double {
        guard let totalData = deviceRemainingSpaceInBytes() as? Double else { return 0}
        let netflixData = SavedContentsListModel.shared.totalCapacity()
        
        return (floor((netflixData / totalData) * 1000)) / 1000
        
    }
    
    func updateNetflixDataConstraints() {
        netflixGraphView.snp.remakeConstraints {
            $0.trailing.equalTo(unUsedGraphView.snp.leading)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(usageGraphView.snp.height)
            $0.width.equalTo(usageGraphView.snp.width).multipliedBy(netflixDataPercentage())
        }
        
    }
    
    
}
