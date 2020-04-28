//
//  CategoryViewController.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/22.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class CategorySelectViewController: UIViewController {
    
    private let rootView = CategorySelectView()
    private let cellID = "CategorySelctTBCell"
    private let categorys = Category().category
    private let categoryKey = Category().keys
    

    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        
        setUI()
    }
    

    //MARK: UI
    private func setUI() {
        rootView.delegate = self
        
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(rootView)
        
        rootView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
   
}

//MARK: CategoryviewDelegate
extension CategorySelectViewController: CategorySelectViewDelegate {
    func didTapdismisButton() {
        print("didTapDismiss")
        dismiss(animated: true)
    }

    
}

//MARK: tableview DataSource
extension CategorySelectViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categorys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rootView.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.text = categorys[categoryKey[indexPath.row]]
        cell.textLabel?.font = .systemFont(ofSize: 18)
        
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
//        tableView.cellForRow(at: indexPath)?.textLabel?.font = .systemFont(ofSize: 18)
        return indexPath
    }
    
    // HomeView에서 바탕화면 categoryView로 교체.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white

        let categoryNum = categoryKey[indexPath.row]
        dismiss(animated: true)
    }
    
}

//MARK: tableView Delegate
extension CategorySelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        CategorySelectViewHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        120
    }
}
