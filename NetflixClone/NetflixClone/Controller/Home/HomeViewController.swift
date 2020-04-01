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
    
    private let cellCount = 2
    
    //MARK: header content
    private let firstCellItem = "titleDummy"
    private let firstCategory = ["로맨스", "한국 드라마", "드라마"]
    private let dibsFlag = false
    
    //MARK: preview content
    private let idPreview = [123, 234, 345, 456, 567]
    private let posterPreview = [UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy")]
    private let titleImagePreview = [UIImage(named: "green"), UIImage(named: "green"), UIImage(named: "green"), UIImage(named: "green"), UIImage(named: "green")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        setConstraints()
    }
    

    //MARK: - UI
    private func setUI() {
//        homeTableView.frame = view.frame
        
        homeTableView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.contentInsetAdjustmentBehavior = .never
        

        homeTableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        
        view.addSubview(homeTableView)
    
    }
    private func setConstraints() {
        homeTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalTo(self.bottomLayoutGuide.snp.bottom)
//            $0.bottom.equalTo(additionalSafeAreaInsets)
        }
    }

    
}

//MARK: - Delegate TableView
extension HomeViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("homeVC: -> heightForRowAt")
        
        let previewCellHeight: CGFloat = tableView.frame.height / 4
        let posterCellHeight: CGFloat = tableView.frame.height / 3
        
        switch indexPath.row {
        case 0:
            print("cell.row \(indexPath.row), cellHeight: \(previewCellHeight)")
            return previewCellHeight
//        case 1:
//            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
//            return posterCellHeight
        default:
            return 100
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height / 4 * 3
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
        return 1 //cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell: UITableViewCell
        print("hoveVC:  Datasource cellForRowAt row = \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
        
        cell.delegate = self

        cell.configure(id: idPreview, poster: posterPreview as! [UIImage], titleImage: titleImagePreview as! [UIImage])
        
        return cell
    }
    
    
}

//MARK: - PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    func selectCell() {
        let contentVC = ContentViewController()
        
        present(contentVC, animated: true)
    }
    
    
}
