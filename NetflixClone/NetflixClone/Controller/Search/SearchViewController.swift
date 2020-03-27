//
//  SearchViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    

    let searchView = SearchView()
    let searchController = UISearchController(searchResultsController: nil)
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.searchBarStyle = .minimal
        searchView.frame = view.frame
        view.addSubview(searchView)
        setCollectionView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 50 // 위아래줄
        layout.minimumInteritemSpacing = 20 // 아이템 간 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "basic")
        view.addSubview(collectionView)
    }
    
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basic", for: indexPath)
        cell.backgroundColor = [.red, .green, .blue, .magenta, .gray, .cyan].randomElement()
        return cell
    }
    
    
}
