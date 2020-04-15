//
//  SavedContentListView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol SavedContentsListViewDelegate: class {
    func findStorableContent()
}

class SavedContentsListView: UIView {
    
    weak var delegate: SavedContentsListViewDelegate? {
        didSet {
            noContentsView.delegate = self.delegate
        }
    }
    
    let tableView = UITableView()

    var isNoContents = true {
        didSet {
            noContentsView.isHidden = !self.isNoContents
        }
    }
    private let noContentsView = DoseNotHaveSavedContentsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    private func setUI() {
        [tableView, noContentsView].forEach({
            addSubview($0)
        })
        
        tableView.register(SavedContentCell.self, forCellReuseIdentifier: SavedContentCell.identifier)
        
        tableView.backgroundColor = .setNetfilxColor(name: .black)
        tableView.separatorStyle = .none
        
    }
    
    private func setConstraint() {
        
        let guide = safeAreaLayoutGuide
        
        noContentsView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        tableView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalTo(guide)
        })
    }
    
    
    
}
