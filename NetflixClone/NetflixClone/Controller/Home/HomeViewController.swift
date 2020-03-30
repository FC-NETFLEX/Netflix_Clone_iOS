//
//  HomeViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    //    private let homeView = HomeView()
    private let homeTableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellCount = 1
    
    // 첫번째 cell content
    private let firstCellItem = "titleDummy"
    private let firstCategory = ["로맨스", "한국 드라마", "드라마"]
    private let dibsFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        
    }
    
    
    //MARK: - UI
    private func setUI() {
        homeTableView.frame = view.frame
        
        homeTableView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.contentInsetAdjustmentBehavior = .never
        
        homeTableView.register(HomeTitleContentTableViewCell.self, forCellReuseIdentifier: HomeTitleContentTableViewCell.identifier)
        homeTableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        
        view.addSubview(homeTableView)
    
    }

    
}

//MARK: - Delegate TableView
extension HomeViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let halfDiviceHight = view.frame.height / 2
        
        
        switch indexPath.row {
        case 0:
            print("case1")
            return halfDiviceHight
        default:
            return 100
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 2
    }
    
    
    
}

//MARK: - Datasource TableView
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = HomeviewTitle()
        header.configure(poster: UIImage(named: firstCellItem)!, category: firstCategory, dibs: dibsFlag)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell: UITableViewCell
        print("HomeViewController Datasource cellForRowAt row = \(indexPath.row)")
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTitleContentTableViewCell.identifier, for: indexPath) as! HomeTitleContentTableViewCell
        cell.configure(poster: UIImage(named: firstCellItem)!, category: firstCategory, dibs: dibsFlag)
        
        
        
        return cell
    }
    
    
}
