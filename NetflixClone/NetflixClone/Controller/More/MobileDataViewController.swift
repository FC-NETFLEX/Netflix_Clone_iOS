//
//  MobileDataViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/18.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class MobileDataViewController: UIViewController {
    
    struct MobileDataCellStatus {
        let title: String
        var status: Bool
        let cellType: CellType
        
        enum CellType {
            case switchType
            case markType
        }
    }
    var list: [MobileDataCellStatus] = [
        MobileDataCellStatus(title: "자동", status: false, cellType: .switchType),
        MobileDataCellStatus(title: "Wi-Fi에서만 저장", status: false, cellType: .markType),
        MobileDataCellStatus(title: "데이터 절약하기", status: true, cellType: .markType),
        MobileDataCellStatus(title: "데이터 최대 사용", status: false, cellType: .markType)
    ]
    
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 15, weight: .regular)]
        
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
        mobileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        mobileTableView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalTo(guide)
        }
    }
    private func checkMarkOn(cell: MobileDataTableViewCell) {
        cell.accessoryType = .checkmark
    }
    
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension MobileDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch list[indexPath.row].cellType {
        case .switchType:
            let cell = tableView.dequeueReusableCell(withIdentifier: MobileDataTableViewCell.identifier) as! MobileDataTableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.text = list[indexPath.row].title
            cell.textLabel?.text = list[indexPath.row].title
            cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = .dynamicFont(fontSize: 12, weight: .regular)
            cell.delegate = self
            
            return cell
            
        case .markType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = list[indexPath.row].title
            cell.textLabel?.font = .dynamicFont(fontSize: 12, weight: .regular)
            
            switch list[0].status {
            case true:
                cell.textLabel?.textColor = .gray
                cell.accessoryType = .none
                
            case false:
                cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
                cell.textLabel?.textColor = .white
                cell.accessoryType = list[indexPath.row].status ? .checkmark : .none
            }
            return cell
        }
    }
    
}

extension MobileDataViewController: UITableViewDelegate {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }

        print(indexPath.row)
        
        for (index, _) in list.enumerated() {
            guard index != 0 else { continue }
            print(list[indexPath.row].status)
            print(list[index].status)
           
            list[index].status = indexPath.row == index
            
//            if indexPath.row == index {
//                list[index].status = true
//            } else {
//                list[index].status = false
//            }
        }
        
        mobileTableView.reloadData()
        
    }
    
}
extension MobileDataViewController: MobileDataTableViewCellDelegate {
    func autoSwitchIsOn(status: Bool) {
        list[0].status = status
        mobileTableView.reloadData()
    }
    
}
