//
//  PreviewTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol PreviewTableViewCellDelegate: class {
    func selectCell() -> ()
}

class PreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PreviewTableViewCell"
    
    weak var delegate: PreviewTableViewCellDelegate?
    
    private let flowLayout = UICollectionViewFlowLayout()
//    private let previewConllectionView = UICollectionView()
    private lazy var previewConllectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//    private let previewConllectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        return UICollectionView(frame: .zero, collectionViewLayout: layout)
//    }()

    private var idData = [Int]()
    private var posterData = [UIImage]()
    private var titleData = [UIImage]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        
        flowLayout.scrollDirection = .horizontal

            
        previewConllectionView.dataSource = self
        previewConllectionView.delegate = self
        
        
        previewConllectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        
        contentView.addSubview(previewConllectionView)
        
       
    }
    
    private func setConstraints() {
        let height = round(UIScreen.main.bounds.height / 3)
       
        print("************************************\n")
        print("PreviewTableViewCell: setConstraints  -> height: \(height)")
        print("************************************\n")

        
        previewConllectionView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
        
  
    //MARK: - configure
    func configure(id: [Int], poster: [UIImage], titleImage: [UIImage]) {
        self.idData = id
        self.posterData = poster
        self.titleData = titleImage
    }

}

extension PreviewTableViewCell: UICollectionViewDataSource {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("PreviewtableViewCell: idData.count \(idData.count)")
        return idData.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = previewConllectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.identifier, for: indexPath) as! PreviewCollectionViewCell
        
        cell.configure(color: .red, poster: posterData[indexPath.row], title: titleData[indexPath.row])
        
        return cell
    }
    
    
}

extension PreviewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 5
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let linSpacing: CGFloat = 10

        return linSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let linSpacing: CGFloat = 10

        return linSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = round(collectionView.frame.width / 3.5)
        let cellHeight = round(collectionView.frame.height - (15 * 2))
        
        print("------------------------------------------\n")
        print("PreviewTableViewCell: cellWidth: \(cellWidth), cellHeight: \(cellHeight)")
        print("------------------------------------------\n")

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectCell()
    }
}


