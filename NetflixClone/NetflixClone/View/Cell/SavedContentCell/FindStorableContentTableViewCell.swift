//
//  FindStorableContentTableViewCell.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol FindStorableContentTableViewCellDelegate: class {
    func selectedContent(contentID: Int)
}

class FindStorableContentTableViewCell: UITableViewCell {
    
    static let identifier = "FindStorableContentTableViewCell"
    
    weak var delegate: FindStorableContentTableViewCellDelegate?
    
    private var contents: [StorableContent] = []
    
    private let categoryLabel = UILabel()
    private let flowLayout: UICollectionViewFlowLayout
    private let collectionView: UICollectionView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        self.flowLayout = layout
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    private func setUI() {
//        print(#function, contentView.frame)
        backgroundColor = .setNetfilxColor(name: .black)
        
        [categoryLabel, collectionView].forEach({
            contentView.addSubview($0)
        })
        
        categoryLabel.textColor = .setNetfilxColor(name: .white)
        categoryLabel.font = .dynamicFont(fontSize: 16, weight: .bold)
        
        collectionView.register(FindStorableCollectionViewCell.self, forCellWithReuseIdentifier: FindStorableCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        flowLayout.scrollDirection = .horizontal
        
    }
    
    private func setConstraint() {
        
        let yInset = CGFloat.dynamicYMargin(margin: 16)
        let leftInset = CGFloat.dynamicXMargin(margin: 8)
        let yMargin = CGFloat.dynamicYMargin(margin: 8)
        
        categoryLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(leftInset)
        })
        
        collectionView.snp.makeConstraints({
            $0.top.equalTo(categoryLabel.snp.bottom).offset(yMargin)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-yInset)
        })
    }
    
    //MARK: Action
    
    func configure(categoryName: String?, contents: [StorableContent]) {
        categoryLabel.text = categoryName
        self.contents = contents
        collectionView.reloadData()
    }
    
//    private func setCollectionViewLayout() {
//        flowLayout.scrollDirection = .horizontal
//
//        flowLayout.minimumLineSpacing = 8
//        flowLayout.minimumInteritemSpacing = 8
//        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//
//        let width = collectionView.bounds.width / 3.3
//        let height = collectionView.bounds.height - 16
//        let itemSize = CGSize(width: width, height: height)
//        flowLayout.itemSize = itemSize
//        print(itemSize)
//        collectionView.reloadData()
//
//    }
    
}


//MARK: UICollectionViewDataSource
extension FindStorableContentTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FindStorableCollectionViewCell.identifier, for: indexPath) as! FindStorableCollectionViewCell
        cell.title = contents[indexPath.row].title
        return cell
    }
    
    
}


//MARK: UICollectionViewDelegateFlowLayout
extension FindStorableContentTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! FindStorableCollectionViewCell
        let imageURLString = contents[indexPath.row].imageURLString
        cell.setPosterImage(imageURLString: imageURLString)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 16
        let width = collectionView.bounds.height * 0.6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedContent(contentID: contents[indexPath.row].contentID)
    }
    
}

