//
//  AppSetUpViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class AppSetUpViewController: UIViewController {
    
    let appSetUpTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setNetfilxColor(name: .black)
        setNavigationBar()
        setUI()
        setConstraints()
    }
    func setNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .setNetfilxColor(name: .black)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 15, weight: .regular)]
        
        let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .setNetfilxColor(name: .white)
        
        navigationItem.leftBarButtonItem = backButton
        
        title = "앱 설정"
    }
    func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)
        [appSetUpTableView].forEach {
            view.addSubview($0)
        }
        appSetUpTableView.backgroundColor = .setNetfilxColor(name: .black)
        appSetUpTableView.separatorColor = .setNetfilxColor(name: .black)
        appSetUpTableView.delegate = self
        appSetUpTableView.dataSource = self
        appSetUpTableView.register(AppSetUpTableViewCell.self, forCellReuseIdentifier: AppSetUpTableViewCell.identifier)
        appSetUpTableView.register(UsingDataGraphCellTableViewCell.self, forCellReuseIdentifier: UsingDataGraphCellTableViewCell.identifier)
        
    }
    func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        appSetUpTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(guide)
        }
        
    }
    
    private func alertAction() {
        
        let savedContentsCount = SavedContentsListModel.shared.totalConetntCount
        
        if savedContentsCount != 0 {
            let alert = UIAlertController(title: "저장한 콘텐츠 모두 삭제", message: "저장하신 콘텐츠 \(savedContentsCount)편을 모두 삭제하시겠어요?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
            }
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                SavedContentsListModel.shared.deleteAllFiles()
                guard let dataCell = self.appSetUpTableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? UsingDataGraphCellTableViewCell else { return }
                //                self.appSetUpTableView.reloadData()
                dataCell.setConfigure()
            }
            alert.addAction(ok)
            alert.addAction(delete)
            present(alert, animated: true)
        }
    }
    private func fastURLScheme() {
        guard
            let url = URL(string: "http://fast.com/ko/"),
            UIApplication.shared.canOpenURL(url)
            else { return }
        
        UIApplication.shared.open(url)
        
    }
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}
extension AppSetUpViewController: AppSetupTableViewCellDelegate {    
    func wifiSwitchDidTap() {
        print("스위치 온")
    }
    
}
extension AppSetUpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        ASData.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .setNetfilxColor(name:.black)
        label.text = ASData[section].dataHeader
        label.font = UIFont.dynamicFont(fontSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ASData[section].settingData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [1,2]:
            let usingCell = tableView.dequeueReusableCell(withIdentifier: UsingDataGraphCellTableViewCell.identifier, for: indexPath) as! UsingDataGraphCellTableViewCell
            //            usingCell.setConfigure()
            usingCell.selectionStyle = .none
            
            return usingCell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppSetUpTableViewCell.identifier) as! AppSetUpTableViewCell
            let date = ASData[indexPath.section].settingData[indexPath.row]
            
            cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.dynamicFont(fontSize: 14, weight: .regular)
            cell.imageView?.image = UIImage(named: date.appSetImage)
            cell.textLabel?.text = date.text
            //            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(indexPath: indexPath)
            
            return cell
        }
    }
}
extension AppSetUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath {
        case [0,0]:
            let mobileVC = MobileDataViewController()
            navigationController?.pushViewController(mobileVC, animated: true)
        case [1,0]:
            print("wifi에서만 저장")
        case [1,1]:
            alertAction()
        case [2,0]:
            fastURLScheme()
        default:
            break
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}




