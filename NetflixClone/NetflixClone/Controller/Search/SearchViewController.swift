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
    lazy var searchBar = self.searchController.searchBar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        
        self.definesPresentationContext = true
        
        
        setSearchBarInNavigation()
    }
    
    private func setSearchBarInNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.setValue("취소", forKey: "cancelButtonText")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)

        
        // searchBar 커서 색 변경
        searchBar.tintColor = UIColor.setNetfilxColor(name: .white)
        
        // searchBar 주변 색 변경
        searchBar.barTintColor = UIColor.setNetfilxColor(name: .black)
        
        // searchTextField 내부 세팅
        searchBar.placeholder = "검색"
        
        searchBar.searchTextField.backgroundColor = UIColor.setNetfilxColor(name: .netflixDarkGray)
        searchBar.searchTextField.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        searchBar.searchTextField.clearButtonMode = .always
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.setNetfilxColor(name: .white)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBar.setShowsCancelButton(true, animated: true)
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
