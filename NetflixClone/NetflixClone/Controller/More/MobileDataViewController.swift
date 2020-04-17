//
//  MobileDataViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/18.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class MobileDataViewController: UIViewController {
  
    let mobileTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .setNetfilxColor(name: .white)
        
        navigationItem.leftBarButtonItem = backButton
        
        title = "모바일 데이터 이용 설정"
    }
    private func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)
        [mobileTableView].forEach {
            view.addSubview($0)
        }
        mobileTableView.delegate = self
        mobileTableView.dataSource = self
        mobileTableView.separatorColor = .setNetfilxColor(name: .black)
        mobileTableView.backgroundColor = .setNetfilxColor(name: .black)
        mobileTableView.register(MobileDataTableViewCell.self, forCellReuseIdentifier: MobileDataTableViewCell.identifier)
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        mobileTableView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalTo(guide)
        }
    }
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension MobileDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .setNetfilxColor(name:.black)
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mobileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MobileDataTableViewCell.identifier) as! MobileDataTableViewCell
        
        cell.textLabel?.text = mobileData[indexPath.row]
        cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        cell.accessoryType = .checkmark
        cell.tag = indexPath.row
        cell.delegate = self
        cell.mobileCellConfigure(indexPath: indexPath)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? MobileDataTableViewCell else { return }
        print(indexPath)

       
    }
    
}

extension MobileDataViewController: UITableViewDelegate {


}
extension MobileDataViewController: MobileDataTableViewCellDelegate {
    func autoSwitchIsOn(autoSwitch: UISwitch) {
        if autoSwitch.isOn == true {
            print("온")
            
            
        } else {
            print("오프")
        }
    }
    
    
}
