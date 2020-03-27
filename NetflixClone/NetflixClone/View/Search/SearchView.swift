//
//  SearchView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class SearchView: UIView {
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar()
    private let searchCancleButton = UIButton()
    private let backGroundOfCollectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.setNetfilxColor(name: .black)
        
//        setUI()
//        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI 세팅
    private func setUI() {
        [searchBar, searchCancleButton, backGroundOfCollectionView].forEach {
            self.addSubview($0)
        }
        
        // 포커싱 안되어있을 때는 placeHolder 센터에 있다가. 포커싱 되는 순간 왼쪽이동
        // 돋보기 모양, 컬러 바꿔줄것
        
        // MARK: - SearchBar 세팅
        // searchBar 취소 버튼 세팅
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        searchBar.setValue("취소", forKey: "cancelButtonText")
        
        // searchBar 커서 색 변경
        searchBar.tintColor = UIColor.setNetfilxColor(name: .white)
        
        // searchBar 주변 색 변경
        searchBar.barTintColor = UIColor.setNetfilxColor(name: .black)
        
        // searchTextField 내부 세팅
        searchBar.placeholder = "검색"
        
        searchBar.searchTextField.backgroundColor = UIColor.setNetfilxColor(name: .netfilxDarkGray)
        
        searchBar.searchTextField.clearButtonMode = .always
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.setNetfilxColor(name: .white)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBar.setShowsCancelButton(true, animated: true)
        
        // MARK: - Collection View 세팅
        backGroundOfCollectionView.backgroundColor = UIColor.setNetfilxColor(name: .backgroundGray)
    }
    
    // MARK: Constraints 세팅
    private func setConstraints() {
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        backGroundOfCollectionView.snp.makeConstraints { (make) -> Void in
            
        }
    }
}
