//
//  NetflixView.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/20.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class NetflixView: UIView {

    let deviceImage = UIImageView()
    let netflixDeviceLabel = UILabel()
    let deviceLabel = UILabel()
    let tvImage = UIImageView()
    let padImage = UIImageView()
    let macImage = UIImageView()
    let phoneImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        backgroundColor = #colorLiteral(red: 0.1336453046, green: 0.1336453046, blue: 0.1336453046, alpha: 1)

        [deviceImage,netflixDeviceLabel,deviceLabel,tvImage,padImage,macImage,phoneImage].forEach {
            addSubview($0)
        }
        deviceImage.image = UIImage(named: "디바이스")
        deviceImage.contentMode = .scaleAspectFill

        netflixDeviceLabel.text = "다양한 디바이스에서 영화, TV프로그램을 무제한으로. "
        netflixDeviceLabel.textColor = .setNetfilxColor(name: .white)
        netflixDeviceLabel.font = UIFont.dynamicFont(fontSize: 15.5, weight: .bold)
        

        deviceLabel.text = "각종 영화와 TV프로그램을 스마트폰, 태블릿, 노트북, TV에서 무제한으로\n스트리밍하세요. 추가요금이 전혀 없습니다.\n마음에 드는 콘텐츠를 원하는 시간에 원하는 만큼 시청하세요."
        deviceLabel.numberOfLines = 0
        deviceLabel.textColor = .setNetfilxColor(name: .white)
        deviceLabel.font = UIFont.dynamicFont(fontSize: 12, weight: .regular)
        

        tvImage.image = UIImage(named: "티비")
        tvImage.contentMode = .scaleAspectFill

        macImage.image = UIImage(named: "맥북")
        macImage.contentMode = .scaleAspectFill

        padImage.image = UIImage(named: "패드")
        padImage.contentMode = .scaleAspectFill

        phoneImage.image = UIImage(named: "아이폰")
        phoneImage.contentMode = .scaleAspectFill

    }
    func setConstraints() {
        let margin: CGFloat = 10

        deviceImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(margin * 2)
            $0.leading.equalToSuperview().inset(margin)
            $0.height.equalTo(self.snp.height).multipliedBy(0.13)
            $0.width.equalTo(deviceImage.snp.height)
        }
        netflixDeviceLabel.snp.makeConstraints {
            $0.centerY.equalTo(deviceImage.snp.centerY)
            $0.leading.equalTo(deviceImage.snp.trailing).offset(margin)

        }
        deviceLabel.snp.makeConstraints {
            $0.top.equalTo(netflixDeviceLabel.snp.bottom).offset(margin)
            $0.leading.equalToSuperview().inset(margin)

        }

        tvImage.snp.makeConstraints {
            $0.top.equalTo(deviceLabel.snp.bottom).offset(margin * 2)
            $0.leading.equalToSuperview().inset(margin * 4)
            $0.height.equalTo(self.snp.height).multipliedBy(0.3)
            $0.width.equalTo(tvImage.snp.height)

        }
        macImage.snp.makeConstraints {
            $0.bottom.equalTo(tvImage.snp.bottom)
            $0.leading.equalTo(tvImage.snp.trailing).inset(-margin * 4)
            $0.height.equalTo(self.snp.height).multipliedBy(0.3)
            $0.width.equalTo(macImage.snp.height)
        }
        padImage.snp.makeConstraints {
           $0.bottom.equalTo(tvImage.snp.bottom)
            $0.leading.equalTo(macImage.snp.trailing).inset(-margin * 4)
            $0.height.equalTo(self.snp.height).multipliedBy(0.25)
            $0.width.equalTo(padImage.snp.height)
        }
        phoneImage.snp.makeConstraints {
           $0.bottom.equalTo(tvImage.snp.bottom)
            $0.leading.equalTo(padImage.snp.trailing).inset(-margin * 3)
            $0.height.equalTo(self.snp.height).multipliedBy(0.25)
            $0.width.equalTo(phoneImage.snp.height)

        }




    }


}
