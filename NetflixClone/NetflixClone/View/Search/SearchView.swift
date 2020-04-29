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
    let noSearchResultsLabel = UILabel()
    var searchResultCollectionView: UICollectionView = {
        let searchResultFlowLayout = UICollectionViewFlowLayout()
        searchResultFlowLayout.headerReferenceSize = CGSize(width: 60, height: CGFloat.dynamicYMargin(margin: 20))
        searchResultFlowLayout.sectionHeadersPinToVisibleBounds = true
        return UICollectionView(frame: .zero, collectionViewLayout: searchResultFlowLayout)
    }()
    
    private let flowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)
    
    private enum UI {
        static let itemsInLine: CGFloat = 3
        static let linesOnScreen: CGFloat = 3.5
        static let itemSpacing: CGFloat = CGFloat.dynamicXMargin(margin: 10)
        static let lineSpacing: CGFloat = CGFloat.dynamicYMargin(margin: 10)
        static let edgeInsets = UIEdgeInsets(top: CGFloat.dynamicYMargin(margin: 10), left: CGFloat.dynamicXMargin(margin: 10), bottom: CGFloat.dynamicYMargin(margin: 10), right: CGFloat.dynamicXMargin(margin: 10))
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setConstraints()
        setCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
    }
    
    // MARK: UI 세팅
    private func setUI() {
        [backGroundOfCollectionView, searchResultCollectionView, noSearchResultsLabel].forEach {
            backGroundOfCollectionView.backgroundColor = UIColor.setNetfilxColor(name: .backgroundGray)
            self.addSubview($0)
        }
        noSearchResultsLabel.text = "검색어와 일치하는 결과가 없습니다."
        noSearchResultsLabel.textColor = UIColor.setNetfilxColor(name: .white)
        noSearchResultsLabel.font = UIFont.dynamicFont(fontSize: 25, weight: .regular)
        noSearchResultsLabel.isHidden = true
    }
    
    private func setCollectionView() {
        searchResultCollectionView.register(ContentsBasicItem.self, forCellWithReuseIdentifier: ContentsBasicItem.identifier)
        searchResultCollectionView.register(
            SearchResultCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchResultCollectionViewHeader.identifier)
        
        searchResultCollectionView.backgroundColor = UIColor.setNetfilxColor(name: .backgroundGray)
    }
    
    // MARK: Constraints 세팅
    private func setConstraints() {
        searchResultCollectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        noSearchResultsLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func setFlowLayout() -> CGSize {
        let itemSpacing = flowLayout.itemSpacing * (flowLayout.itemsInLine - 1) //
        let lineSpacing = flowLayout.lineSpacing * (flowLayout.linesOnScreen - 1) // 5 * 2.5
        let horizontalInset = flowLayout.edgeInsets.left + flowLayout.edgeInsets.right
        let verticalInset = flowLayout.edgeInsets.top + flowLayout.edgeInsets.bottom
        
        let horizontalSpacing = itemSpacing + horizontalInset
        let verticalSpacing = lineSpacing + verticalInset
        
        let contentWidth = searchResultCollectionView.frame.width - horizontalSpacing
        let contentHeight = searchResultCollectionView.frame.height - verticalSpacing
        let width = contentWidth / flowLayout.itemsInLine
        let height = contentHeight / flowLayout.linesOnScreen
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down) - 1)
    }
}


