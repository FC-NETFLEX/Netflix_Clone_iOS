//
//  PreviewTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol PreviewTableViewCellDelegate: class {
    func selectCell(index: Int) -> ()
}

class PreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PreviewTC"
    
    weak var delegate: PreviewTableViewCellDelegate?
    
    private let flowLayout = UICollectionViewFlowLayout()
    private let sectionHeight: CGFloat = 24
    
    private let headerLabel = UILabel()
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
        
        flowLayout.scrollDirection = .horizontal
        
        headerLabel.text = "미리보기"
        headerLabel.font = HeaderFont
        headerLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        headerLabel.backgroundColor = .clear
            
        previewConllectionView.dataSource = self
        previewConllectionView.delegate = self
        previewConllectionView.backgroundColor = .clear
        
        
        previewConllectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(previewConllectionView)
        
       
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
        
        previewConllectionView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
        
  
    //MARK: - configure
    func configure(id: [Int], posters: [UIImage], titleImages: [UIImage]) {
//    func configure(id: [Int], poster: [String], titleImage: [String?]) {
//        var posters = [UIImage]()
//        var titleImages = [UIImage]()
//
//        poster.forEach { posters.append(UIImage(named: $0)!) }
//        titleImage.forEach { titleImages.append(UIImage(named: $0 ?? "")!) }
        
        self.idData = id
        self.posterData = posters
        self.titleData = titleImages
        print("=======preview Configure  idData \(idData.count), posterData \(posterData.count), titleImage \(titleImages)")
        
        previewConllectionView.reloadData()
    }

}

extension PreviewTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        return UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
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
        

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectCell(index: indexPath.row)
    }
}


