//
//  WatchContentsTableViewCell.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/04.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol WatchContentsTableViewDelegate: class {
    func didTapWatchContentPlay(contentID: Int) -> ()
    func didTapWatchContentInfo(contentId: Int) -> ()
}

class WatchContentsTableViewCell: UITableViewCell {
    
    static let identifier = "WatchContentsTC"
    
    weak var delegate: WatchContentsTableViewDelegate?
    
    private let sectionHeight: CGFloat = 24
    
    private let headerLabel = UILabel()
    
//    private var idData = [Int]()
    private var contentIdData = [Int]()
    private var postersData = [URL]()
    private var watchTimesData = [Int]()
    private var playMarksData = [Int]()
    private var url = [URL]()
    
    private let contentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        setUI()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {

        let HeaderFont: UIFont = .boldSystemFont(ofSize: 16)
        
        headerLabel.text = "시청중인 콘텐츠"
        headerLabel.font = HeaderFont
        headerLabel.backgroundColor = .clear
        headerLabel.textColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.white)
        
        contentsCollectionView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        contentsCollectionView.register(WatchContentsCollectionViewCell.self, forCellWithReuseIdentifier: WatchContentsCollectionViewCell.identifier)
        
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        
        contentView.addSubview(contentsCollectionView)
        contentView.addSubview(headerLabel)
    }
    
    private func setContraints() {
        //        contentsCollectionView.frame = contentView.frame
        let headerYMargin: CGFloat = 10
        let headerXMargin: CGFloat = 10
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(headerYMargin)
            $0.leading.equalToSuperview().inset(headerXMargin)
            $0.height.equalTo(sectionHeight - headerYMargin)
        }
        
        contentsCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - configure
    func configure(/*id: [Int], */poster: [URL], watchTime: [Int], playMark: [Int], contentID: [Int]) {

//        self.idData = id
        self.contentIdData = contentID
        self.postersData = poster
        self.watchTimesData = watchTime
        self.playMarksData = playMark
        
        contentsCollectionView.reloadData()
    }
    
}

//MARK: -FlowLayout Delegate
extension WatchContentsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadInputViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 5
        return UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = collectionView.frame.width / 3.5
//        let height: CGFloat = collectionView.frame.height - 20
//        return CGSize(width: width, height: height)
        
        return CGSize(width: 107, height: 199)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    

}

//MARK: -DataSource
extension WatchContentsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = contentsCollectionView.dequeueReusableCell(withReuseIdentifier: WatchContentsCollectionViewCell.identifier, for: indexPath) as! WatchContentsCollectionViewCell
        
        cell.delegate = self
        
        // watchTime -> String
        let watchTime = watchTimesData[indexPath.row]
        let hour = watchTime / 3600
        let minute = (watchTime % 3600) / 60
        let watchString: String
        
        if hour <= 0 {
            watchString = "\(minute)분"
        } else {
            watchString = "\(hour)시간 \(minute)분"
        }
        // playMark -> Double Type 퍼센트로
        let playMarkData = Double(playMarksData[indexPath.row])
        let playLength: Double = ( 100 / ( Double(watchTime) / playMarkData ) ) / 100
        
        cell.configure(/*id: idData[indexPath.row], */contentId: contentIdData[indexPath.row],poster: postersData[indexPath.row], watchTime: watchString, playMark: playLength)
        
        return cell
    }
    
    
}

extension WatchContentsTableViewCell: WatchContentsCollectionViewCellDelegate {
    func didTapWatchPlay(contentID: Int) {
                delegate?.didTapWatchContentPlay(contentID: contentID)
    }
    
    func didTapWatchContentInfo(contentId: Int) {
        delegate?.didTapWatchContentInfo(contentId: contentId)
    }

    
}
