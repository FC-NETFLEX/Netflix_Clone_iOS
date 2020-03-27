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
    private let backGroundOfCollectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.setNetfilxColor(name: .black)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI 세팅
    private func setUI() {
        [backGroundOfCollectionView].forEach {
            backGroundOfCollectionView.backgroundColor = UIColor.setNetfilxColor(name: .backgroundGray)
            self.addSubview($0)
        }
        
        // 포커싱 안되어있을 때는 placeHolder 센터에 있다가. 포커싱 되는 순간 왼쪽이동
        // 돋보기 모양, 컬러 바꿔줄것
        
        // MARK: - SearchBar 세팅
        // searchBar 취소 버튼 세팅
        
        
        // MARK: - Collection View 세팅
        backGroundOfCollectionView.backgroundColor = UIColor.setNetfilxColor(name: .backgroundGray)
    }
    
   
    
    // MARK: Constraints 세팅
    private func setConstraints() {
        backGroundOfCollectionView .snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(5)
            make.leading.equalTo(self.snp.leading).offset(5)
            make.trailing.equalTo(self.snp.trailing).offset(5)
        }
    }
}
