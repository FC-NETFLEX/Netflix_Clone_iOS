//
//  Top10TableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/02.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


protocol Top10TableViewCellDelegate: class {
    func didTapTop10Cell(id: Int) -> ()
}

class Top10TableViewCell: UITableViewCell {
    
    static let identifier = "top10TC"
    
    weak var delegate: Top10TableViewCellDelegate?
    
    private let sectionHeight: CGFloat = 24
    private let collectionFlow = FlowLayout(itemsInLine: 1, linesOnScreen: 1)
    
    private let headerLabel = UILabel()
    
    private var idData = [Int]()
    private var posterData = [String]()
    
    private let contentCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    
    //MARK: - 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {

        let HeaderFont: UIFont = .boldSystemFont(ofSize: 16)
                
        headerLabel.text = "Top10"
        headerLabel.font = HeaderFont
        headerLabel.backgroundColor = .clear
        headerLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        contentCollectionView.register(Top10CollectionViewCell.self, forCellWithReuseIdentifier: Top10CollectionViewCell.identifier)
        
        
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
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - configure
    func configure(id: [Int], poster: [String]) {
        self.idData = id
        self.posterData = poster
        
        contentCollectionView.reloadData()
    }
}


//MARK: - CollectionView DataSource
extension Top10TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return idData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Top10CollectionViewCell.identifier, for: indexPath) as! Top10CollectionViewCell
        
        cell.configure(poster: posterData[indexPath.row], count: indexPath.row)
        
        
        return cell
    }
    
    
}

//MARK: - CollectionView Delegate
extension Top10TableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 가로모드일 때 item 1줄이면 lineSpacing이 가로로 들어간다.
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = round(collectionView.frame.width / 2.5)
//        return CGSize(width: width, height: collectionView.frame.height - 20)
        return CGSize(width: 150, height: 168)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapTop10Cell(id: idData[indexPath.row])
    }
}
