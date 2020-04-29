//
//  CustomButtonView.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/05.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol CustomButtonViewDelegate {
    func togleAction(sender: CustomButtonView, isClicked: Bool)
}

// MARK: 상세화면 버튼 셀에 들어가는 버튼 구현용 커스텀 뷰 (뷰 위에 이미지와 레이블 올리고, 뷰와 똑같은 사이즈의 투명한 버튼 올려서 구현함)
class CustomButtonView: UIView {
    
    
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton()
    
    // MARK: 버튼 토글용 변수
    var isClicked = false
    
    init(imageName: String, labelText: String) {
        super.init(frame: .zero)
        imageView.image = UIImage(systemName: imageName)
        label.text = labelText
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI () {
        [imageView, label, button].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .clear
        imageView.tintColor = UIColor.setNetfilxColor(name: .white)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        isClicked.toggle()
    }
    
    private func setConstraints() {
        let buttonImageSizeMultiplying = 0.2
        let constant5 = CGFloat.dynamicYMargin(margin: 5)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.height.equalTo(self.snp.width).multipliedBy(buttonImageSizeMultiplying)
            $0.top.equalTo(self.snp.top).offset(constant5)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalTo(imageView.snp.centerX)
            $0.top.equalTo(imageView.snp.bottom).offset(constant5)
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self)
        }
    }
    
    
}
