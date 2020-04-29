//
//  HomeView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

//protocol HomeViewDelegate: class {
//    func setMoveContentVC(contentId: Int) -> ()
//    func setMoviePreviewVC(index: Int) -> ()
//}

class HomeView: UIView {
    
//    weak var delegate: HomeViewDelegate?
    
    let homeTableView = UITableView(frame: .zero, style: .grouped)
    private let cellCount = 5
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        homeTableView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        homeTableView.separatorStyle = .none

        
        homeTableView.contentInsetAdjustmentBehavior = .never
        
        
        homeTableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        homeTableView.register(LatestMovieTableViewCell.self, forCellReuseIdentifier: LatestMovieTableViewCell.indentifier)
        homeTableView.register(Top10TableViewCell.self, forCellReuseIdentifier: Top10TableViewCell.identifier)
        homeTableView.register(WatchContentsTableViewCell.self, forCellReuseIdentifier: WatchContentsTableViewCell.identifier)
        
        addSubview(homeTableView)

    }
    
    private func setConstraints() {
        homeTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
}
