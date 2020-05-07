//
//  SaveContentStatusView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/09.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol SaveContentStatusViewDelegate: class {
    func changeStatus(status: SaveContentStatus)
}

class SaveContentStatusView: UIButton {
    
    weak var delegate: SaveContentStatusViewDelegate?
    
    private var status: SaveContentStatus {
        didSet {
            switch self.status {
            case .downLoading:
                setDownLoding()
            case .waiting:
                setWating()
            case .saved:
                setSaved()
            case .doseNotSave:
                setDoseNotSave()
            }
            delegate?.changeStatus(status: self.status)
        }
    }
    
    var downLoadStatus: SaveContentStatus {
        get {
            return self.status
        }
        set {
            self.status = newValue
        }
    }
    
    var id: Int {
        didSet {
            removeNotification(id: oldValue)
            addNotification(id: self.id)
        }
    }
    
    private let statusImageView = UIImageView()
    private let downLoadStatusView = UIView()
    
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var finishedDrawLayers = false
    
    init(id: Int, status: SaveContentStatus) {
        self.status = status
        self.id = id
        super.init(frame: .zero)
        setUI()
        setConstraints()
        addNotification(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        }
    }
    
    deinit {
        print("SaveContentStatusView: deinit")
        removeNotification(id: id)
    }
    
    //MARK: UI
    private func setUI() {
        [statusImageView, downLoadStatusView].forEach({
            addSubview($0)
        })
        
        //        statusImageView.image = UIImage(named: "saveContent")
        statusImageView.contentMode = .scaleAspectFill
        statusImageView.tintColor = .setNetfilxColor(name: .white)
        downLoadStatusView.backgroundColor = .setNetfilxColor(name: .downLoad)
        
        status = downLoadStatus
        
        
    }
    
    private func setConstraints() {
        statusImageView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        downLoadStatusView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.3)
        })
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        if status == .doseNotSave {
//            addNotification()
//        }
//    }
    
    
    //MARK: Action
    
    // 저장 완료 상태로 UI세팅
    private func setSaved() {
        statusImageView.isHidden = false
        downLoadStatusView.isHidden = true
        foregroundLayer.isHidden = true
        backgroundLayer.isHidden = true
        statusImageView.image = UIImage(named: "saveContent")
    }
    
    // 저장 대기 상태로 UI 세팅
    private func setWating() {
        statusImageView.isHidden = false
        downLoadStatusView.isHidden = false
        foregroundLayer.isHidden = true
        backgroundLayer.isHidden = true
        statusImageView.image = UIImage(named: "waitingDownLoad")
    }
    
    // 다운로드중 상태로 UI 세팅
    private func setDownLoding() {
        statusImageView.isHidden = true
        downLoadStatusView.isHidden = false
        foregroundLayer.isHidden = false
        backgroundLayer.isHidden = false
        drawDownLoadingBackgroundLayer()
        drawDownLoadingForegroundLayer()
    }
    
    // 다운로드 하지않은 상태
    private func setDoseNotSave() {
        statusImageView.isHidden = false
        downLoadStatusView.isHidden = true
        foregroundLayer.isHidden = true
        backgroundLayer.isHidden = true
        statusImageView.image = UIImage(systemName: "arrow.down.to.line")
    }
    
    // 다운로드 원형 프로그레스바 그리기
    private func drawDownLoadingForegroundLayer() {
        //        guard layer.sublayers?.firstIndex(of: foregroundLayer) == nil else { return }
        let lineWidth = bounds.width * 0.15
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
        //        guard layer.sublayers?.firstIndex(of: backgroundLayer) == nil else { return }
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
    
    
    //MARK: Notification
    //노티피케이션 등록
    private func addNotification(id: Int) {
        let notificationName = String(id)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(responseOfNotification),
            name: NSNotification.Name(notificationName),
            object: nil)
    }
    
    private func removeNotification(id: Int) {
        let notificationName = String(id)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationName), object: nil)
    }
    
    // 노티 액션
    @objc func responseOfNotification(_ notification: Notification) {
        guard let downLoadStatus = notification.userInfo?["status"] as? DownLoadStatus else { return }
        DispatchQueue.main.async {
            self.status = downLoadStatus.status
            self.foregroundLayer.strokeEnd = downLoadStatus.percent
        }
        if downLoadStatus.status != .downLoading {
            print(#function, downLoadStatus.status)
        }
        
    }
    
    //MARK: Touch Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1
    }
    
    
    
}


