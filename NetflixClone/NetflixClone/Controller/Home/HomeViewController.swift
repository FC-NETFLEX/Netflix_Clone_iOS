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
    
    private let cellCount = 4
    
    //MARK: header content
    private let firstCellItem = "titleDummy"
    private let firstCategory = ["로맨스", "한국 드라마", "드라마"]
    private let dibsFlag = false
    private let firstTitleImage = UIImage(named: "white")
    
    //MARK: preview content
    private let idPreview = [123, 234, 345, 456, 567]
    private let posterPreview = [UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy")]
    private let titleImagePreview = [UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white")]
    
    //MARK: LatestMovie content
    private let idLatestMovie = [123, 234, 345, 456, 567]
    private let posterLatestMovie = [UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy")]
    
    //MARK: Top10 content
    private let idTop10 = [123, 234, 345, 456, 567, 678, 789, 890,910, 111]
    private let posterTop10 = [UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy")]
    
    //MARK: WatchContents
    //poster: <#T##[UIImage]#>, watchTime: T##[String], playMark: <#T##[Int64]#>, url: <#T##URL#>
    private let posterWatch = [UIImage(named: "포스터"), UIImage(named: "top10Dummy"), UIImage(named: "posterCellDummy"), UIImage(named: "포스터")]
    private let watchTimekWatch: [Int64] = [5400, 5000, 5700, 3600]
    private let playMark: [Int64] = [2500, 700, 5000, 1000]
    
    
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
        homeTableView.register(LatestMovieTableViewCell.self, forCellReuseIdentifier: LatestMovieTableViewCell.indentifier)
        homeTableView.register(Top10TableViewCell.self, forCellReuseIdentifier: Top10TableViewCell.identifier)
        homeTableView.register(WatchContentsTableViewCell.self, forCellReuseIdentifier: WatchContentsTableViewCell.identifier)
        
        view.addSubview(homeTableView)
        
    }
    private func setConstraints() {
        homeTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

//MARK: - Delegate TableView
extension HomeViewController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("homeVC: -> heightForRowAt")
        
        let previewCellHeight: CGFloat = tableView.frame.height / 4
        let posterCellHeight: CGFloat = tableView.frame.height / 4 + 30
        let watchCellHeight: CGFloat = tableView.frame.height / 3
        switch indexPath.row {
        case 0:
            print("cell.row \(indexPath.row), cellHeight: \(previewCellHeight)")
            return previewCellHeight
        case 1, 2:
            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return posterCellHeight
        case 3:
            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return watchCellHeight
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
        header.configure(poster: UIImage(named: firstCellItem)!, category: firstCategory, dibs: dibsFlag, titleImage: self.firstTitleImage!)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hoveVC:  Datasource cellForRowAt row = \(indexPath.row)")
        
        
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell.delegate = self
            
            previewCell.configure(id: idPreview, poster: posterPreview as! [UIImage], titleImage: titleImagePreview as! [UIImage])
            
            cell = previewCell
        case 1:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie as! [UIImage])
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            top10Cell.delegate = self
            top10Cell.configure(id: idTop10, poster: posterTop10 as! [UIImage])
            cell = top10Cell
        case 3:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            watchContentCell.configure(poster: posterWatch as! [UIImage], watchTime: watchTimekWatch, playMark: playMark/*, url: <#T##URL#>*/)
            
            cell = watchContentCell
        default:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            cell = UITableViewCell()
        }
        
        
        return cell
    }
    
    
}

//MARK: - PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    func selectCell() {
        print("HomveViewController 미리보기 cell 클릭")
        let contentVC = ContentViewController()
        
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - LatestMoview Delegate
extension HomeViewController: LatestMovieTableViewCellDelegate {
    func didTabLatestMovieCell() {
        let contentVC = ContentViewController()
        
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - Top10 Delegate
extension HomeViewController: Top10TableViewCellDelegate {
    func didTabTop10Cell() {
        let contentVC = ContentViewController()
        
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - WatchContentCell Delegate
extension HomeViewController: WatchContentsTableViewDelegate {
    func didTabWatchContentCell() {
        print("WatchContentCell Click")
    }
    
    
}
