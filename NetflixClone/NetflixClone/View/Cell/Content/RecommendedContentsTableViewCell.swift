//
//  RecommendedContentsTableViewCell.swift
//  BackgroundImage
//
//  Created by MyMac on 2020/04/02.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

protocol RecommendedCellDalegate: class {
    func didTapRecommendedContents(indexPath: IndexPath) -> ()
}

class RecommendedTableViewCell: UITableViewCell {
    
    static let identifier = "RecommendedTableViewCell"
    private var contents: [SimilarContent] = []
    
    weak var delegate: RecommendedCellDalegate?
    
    private let sectionHeight = CGFloat.dynamicYMargin(margin: 24)
    private let collectionFlow = FlowLayout(itemsInLine: 3, linesOnScreen: 2)
    
    private var headerLabel = UILabel()
    
    private var idData = [Int]()
    private var posterData = [UIImage]()
    
    
    let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = false
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let HeaderFont = UIFont.dynamicFont(fontSize: 20, weight: .bold)
        
        headerLabel.text = "비슷한 콘텐츠"
        headerLabel.font = HeaderFont
        headerLabel.backgroundColor = .clear
        headerLabel.textColor = UIColor.setNetfilxColor(name: .white)
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.isScrollEnabled = false
        contentCollectionView.register(RecommendedCollectionViewItem.self, forCellWithReuseIdentifier: RecommendedCollectionViewItem.identifier)
                
        contentView.addSubview(headerLabel)
        contentView.addSubview(contentCollectionView)
    }
    
    private func setConstraints() {
        let headerYMargin: CGFloat = 10
        let headerXMargin: CGFloat = 10
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(headerYMargin)
            $0.leading.equalTo(headerXMargin)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(sectionHeight - headerYMargin)
        }
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self)
        }
    }
    
    //MARK: - configure
    func configure(contents: [SimilarContent]) {
        self.contents = contents
        contentCollectionView.reloadData()
//        print(contents)
//        self.idData = id
//        self.posterData = poster
//
//        print("Top10TableViewCell: configure idData = \(idData), posterData = \(posterData)")
    }
    
    func setFlowLayout() -> CGSize {
        let itemSpacing = collectionFlow.itemSpacing * (collectionFlow.itemsInLine - 1) //
        let lineSpacing = collectionFlow.lineSpacing * (collectionFlow.linesOnScreen - 1) // 
        let horizontalInset = collectionFlow.edgeInsets.left + collectionFlow.edgeInsets.right
        let verticalInset = collectionFlow.edgeInsets.top + collectionFlow.edgeInsets.bottom
        
        let horizontalSpacing = itemSpacing + horizontalInset
        let verticalSpacing = lineSpacing + verticalInset
        
        let contentWidth = contentCollectionView.frame.width - horizontalSpacing
        let contentHeight = contentCollectionView.frame.height - verticalSpacing
        let width = contentWidth / collectionFlow.itemsInLine
        let height = contentHeight / collectionFlow.linesOnScreen
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down) - 1)
    }
}

extension RecommendedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionFlow.edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionFlow.lineSpacing

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        collectionFlow.itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return setFlowLayout()
    }
    
    // MARK: 추천 컨텐츠의 상세화면으로 이동할 것
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("추천 컨텐츠의 상세화면으로 이동", indexPath)
        delegate?.didTapRecommendedContents(indexPath: indexPath)
    }
}

extension RecommendedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewItem.identifier, for: indexPath) as! RecommendedCollectionViewItem
        
        // MARK: 서버로부터 응답 받은 상세 이미지
        cell.configure(poster: contents[indexPath.row].imageURL) // 더미
        return cell
    }
    
    
}
