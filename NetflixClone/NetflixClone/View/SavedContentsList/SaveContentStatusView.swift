//
//  SaveContentStatusView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
// #0265E8 이미지 색상
class SaveContentStatusView: UIView {
    
    
    private var status = SaveContentStatus.waiting {
        didSet {
            switch self.status {
            case .downLoading:
                setDownLoding()
            case .waiting:
                setWating()
            case .saved:
                setSaved()
            }
        }
    }
    
    private let imageView = UIImageView()
    private let downLoadStatusView = UIView()
    
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var finishedDrawLayers = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [imageView, downLoadStatusView].forEach({
            addSubview($0)
        })
        
        imageView.image = UIImage(named: "saveContent")
        imageView.contentMode = .scaleAspectFill
        
        downLoadStatusView.backgroundColor = .setNetfilxColor(name: .downLoad)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        downLoadStatusView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.3)
        })
    }
    
    // 저장 완료 상태로 UI세팅
    private func setSaved() {
        print(#function)
        imageView.isHidden = false
        downLoadStatusView.isHidden = true
        foregroundLayer.isHidden = true
        backgroundLayer.isHidden = true
        imageView.image = UIImage(named: "saveContent")
    }
    
    // 저장 대기 상태로 UI 세팅
    private func setWating() {
        imageView.isHidden = false
        downLoadStatusView.isHidden = false
        foregroundLayer.isHidden = true
        backgroundLayer.isHidden = true
        imageView.image = UIImage(named: "waitingDownLoad")
    }
    
    // 다운로드중 상태로 UI 세팅
    private func setDownLoding() {
        imageView.isHidden = true
        downLoadStatusView.isHidden = false
        foregroundLayer.isHidden = false
        backgroundLayer.isHidden = false
        drawDownLoadingBackgroundLayer()
        drawDownLoadingForegroundLayer()
    }
    
    // 다운로드 원형 프로그레스바 그리기
    private func drawDownLoadingForegroundLayer() {
        guard layer.sublayers?.firstIndex(of: foregroundLayer) == nil else { return }
        let lineWidth = bounds.width * 0.2
        let radius = (bounds.width - lineWidth) / 2
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 2 + startAngle
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        foregroundLayer.path = path.cgPath
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor.setNetfilxColor(name: .downLoad).cgColor
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.strokeEnd = 0
        layer.addSublayer(foregroundLayer)
    }
    
    // 다운로드 원형 프로그레스바 그리기
    private func drawDownLoadingBackgroundLayer() {
        guard layer.sublayers?.firstIndex(of: backgroundLayer) == nil else { return }
        let lineWidth: CGFloat = bounds.width * 0.05
        let radius: CGFloat = (bounds.width - lineWidth) / 2
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        backgroundLayer.path = path.cgPath
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.strokeColor = UIColor.setNetfilxColor(name: .downLoad).cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)
    }
    
    
}
