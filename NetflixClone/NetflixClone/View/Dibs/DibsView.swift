//
//  DibsView.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/19.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class DibsView: UIView {
    
//    private let flowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    private func setUI() {
        collectionView.register(ContentsBasicItem.self, forCellWithReuseIdentifier: ContentsBasicItem.identifier)
        collectionView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        
        addSubview(collectionView)
    }
    
    private func setConstraints() {
//        let topMargin: CGFloat = 80//round(frame.height / 9)
//        print("DibsView setConstraints topMargin = \(topMargin)")
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    

}
