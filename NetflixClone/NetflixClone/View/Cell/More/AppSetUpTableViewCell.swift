//
//  AppSetUpTableViewCell.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/17.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol AppSetupTableViewCellDelegate: class {
//    func didTapAppSetButton(cell: AppSetUpTableViewCell)
    func wifiSwitchDidTap()
//    func internetSchemeButtonDidTap()
}

class AppSetUpTableViewCell: UITableViewCell {
    
    var delegate: AppSetupTableViewCellDelegate?
    static let identifier = "AppSetUpTableViewCell"
    
    let selectImage = UIImageView()
    let explorerImage = UIImageView()
    let wifiSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [wifiSwitch,selectImage,explorerImage].forEach {
            addSubview($0)
        }
        selectImage.image = UIImage(named: "들어가기")
        selectImage.contentMode = .scaleAspectFill
        selectImage.isHidden = true
        
        explorerImage.image = UIImage(named: "이동")
        explorerImage.contentMode = .scaleAspectFill
        selectImage.isHidden = true
        
        wifiSwitch.onTintColor = #colorLiteral(red: 0.04303120111, green: 0.4391969315, blue: 0.9407585816, alpha: 1)
        wifiSwitch.tintColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        wifiSwitch.isHidden = true
        wifiSwitch.addTarget(self, action: #selector(wifiSwitchDidTap), for: .touchUpInside)
        
        selectionStyle = .none
//
//        moreTapButton.backgroundColor = .clear
//        moreTapButton.addTarget(self, action: #selector(didTapAppSetButton), for: .touchUpInside)
        
    }
    func setConstraints() {
        let margin: CGFloat = 10
        
        selectImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin * 2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.06)
        }
        explorerImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin * 2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.06)
        }
        wifiSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(margin * 2)
            $0.centerY.equalToSuperview()
        }
        
//        moreTapButton.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalToSuperview()
//        }
    }
    
//    @objc func didTapAppSetButton() {
//        delegate?.didTapAppSetButton(cell: self)
//        
//    }
    @objc func wifiSwitchDidTap() {
        delegate?.wifiSwitchDidTap()
        
    }
//    @objc func internetSchemeButtonDidTap() {
//        delegate?.internetSchemeButtonDidTap()
//
//    }
//    private func alertAction() {
//        let alert = UIAlertController(title: "저장한 콘텐츠 모두 삭제", message: "저장하신 콘텐츠 1편을 모두 삭제하시겠어요?", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .default) { _ in
//        }
//        let delete = UIAlertAction(title: "삭제", style: .cancel) { _ in
//        }
//        alert.addAction(ok)
//        alert.addAction(delete)
//    }
    
    func configure(indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            wifiSwitch.isHidden = true
            selectImage.isHidden = false
            explorerImage.isHidden = true
            self.detailTextLabel?.text = "자동"
            self.detailTextLabel?.textColor = .setNetfilxColor(name: .netflixLightGray)
        case [1,0]:
            wifiSwitch.isHidden = false
            selectImage.isHidden = true
            explorerImage.isHidden = true
        case [1,1]:
            wifiSwitch.isHidden = true
            selectImage.isHidden = true
            explorerImage.isHidden = true
        case [2,0]:
            wifiSwitch.isHidden = true
            selectImage.isHidden = true
            explorerImage.isHidden = false
        default:
            break
        }
    }
    
}
