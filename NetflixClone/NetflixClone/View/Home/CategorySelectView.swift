//
//  CategoryView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/22.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol CategorySelectViewDelegate: class {
    func didTapdismisButton() -> ()
    
}

class CategorySelectView: UIView {
    
    weak var delegate: CategorySelectViewDelegate?
    
    private let blurView = UIVisualEffectView()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor.clear.withAlphaComponent(0)//.withAlphaComponent(0)
        backgroundColor = .clear
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    private func setUI() {
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        
        closeButton.setImage(UIImage(named: "close_white"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTabDismissButton(sender:)), for: .touchUpInside)
        
        addSubview(blurView)
        addSubview(tableView)
        addSubview(closeButton)
    }
    
    private func setConstraints() {
        let margin: CGFloat = 30
        let closeButtonSize: CGFloat = 50
        
        
        blurView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(margin)
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(margin)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(closeButtonSize)
        }
    }
    
    @objc private func didTabDismissButton(sender: UIButton) {
        delegate?.didTapdismisButton()
    }
    

}
