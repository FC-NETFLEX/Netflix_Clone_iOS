//
//  HomeViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    //    private let homeView = HomeView()
    private let homeTableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellCount = 5
    
    //MARK: header content
    private let firstCellItem = "titleDummy"
    private let firstCategory = ["로맨스", "한국 드라마", "드라마"]
    private let dibsFlag = false
    private let firstTitleImage = UIImage(named: "white")
    
    //MARK: preview content
    private let idPreview = [123, 234, 345, 456, 567]
    private let posterPreview = [UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy")]
    private let titleImagePreview = [UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white"), UIImage(named: "white")]
    
    //MARK: LatestMovie content
    private let idLatestMovie = [123, 234, 345, 456, 567]
    private let posterLatestMovie = [UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy"), UIImage(named: "posterCellDummy")]
    
    //MARK: Top10 content
    private let idTop10 = [123, 234, 345, 456, 567, 678, 789, 890,910, 111]
    private let posterTop10 = [UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy"), UIImage(named: "top10Dummy")]
    
    //MARK: WatchContents
    //poster: <#T##[UIImage]#>, watchTime: T##[String], playMark: <#T##[Int64]#>, url: <#T##URL#>
    private let posterWatch = [UIImage(named: "포스터"), UIImage(named: "top10Dummy"), UIImage(named: "posterCellDummy"), UIImage(named: "포스터")]
    private let watchTimekWatch: [Int64] = [5400, 5000, 5700, 3600]
    private let playMark: [Int64] = [2500, 700, 5000, 1000]
    
    //MARK: VideoAdvertisement ->
    private var videoAdvertismentCell: VideoAdvertisementTableViewCell?
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // VideoCell의 영상 재생 멈춤
        videoAdvertismentCell?.player?.pause()
    }
    
    //MARK: - UI
    private func setUI() {
        //        homeTableView.frame = view.frame
        
        homeTableView.backgroundColor = UIColor.setNetfilxColor(name: UIColor.ColorAsset.backgroundGray)
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.contentInsetAdjustmentBehavior = .never
        
        
        homeTableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        homeTableView.register(LatestMovieTableViewCell.self, forCellReuseIdentifier: LatestMovieTableViewCell.indentifier)
        homeTableView.register(Top10TableViewCell.self, forCellReuseIdentifier: Top10TableViewCell.identifier)
        homeTableView.register(WatchContentsTableViewCell.self, forCellReuseIdentifier: WatchContentsTableViewCell.identifier)
        
        
        
        //        homeTableView.register(VideoAdvertisementTableViewCell.self, forCellReuseIdentifier: VideoAdvertisementTableViewCell.identifier)
        
        view.addSubview(homeTableView)
        
    }
    private func setConstraints() {
        homeTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

//MARK: - Delegate TableView
extension HomeViewController: UITableViewDelegate {
    
    //MARK: -UITableViewCell willDisplay
    // Video Cell 보이려고 할때 영상 재생되게 하려고
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let videoCell = cell as? VideoAdvertisementTableViewCell else { return }
        print("=============================================================")
        print("\n HomeViewController: TableViewCell willdisplay -> VideoCell!!!!!!!! \n")
        
        videoCell.player?.play()
        
    }
    
    //MARK: -UITableViewCell didEndDisplaying
    // Video Cell 사용안할 때 영상 멈추게 하려고
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoAdvertisementTableViewCell else { return }
        print("=============================================================")
        print("\n HomeViewController: TableViewCell didEndDisplayin -> VideoCell!!!!!!!! \n")
        
        videoCell.player?.pause()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("homeVC: -> heightForRowAt")
        
        let previewCellHeight: CGFloat = tableView.frame.height / 4
        let posterCellHeight: CGFloat = tableView.frame.height / 4 + 30
        let watchCellHeight: CGFloat = tableView.frame.height / 3
        let videoAdvertiseHeight: CGFloat = round(tableView.frame.height / 2.5)
        
        switch indexPath.row {
        case 0:
            print("cell.row \(indexPath.row), cellHeight: \(previewCellHeight)")
            return previewCellHeight
        case 1, 4:
            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return posterCellHeight
        case 2:
            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return videoAdvertiseHeight
        case 3:
            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return watchCellHeight
            
        default:
            return 100
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height / 4 * 3
    }
    
    
    
}

//MARK: - Datasource TableView
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = HomeviewTitle()
        header.configure(poster: UIImage(named: firstCellItem)!, category: firstCategory, dibs: dibsFlag, titleImage: self.firstTitleImage!)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hoveVC:  Datasource cellForRowAt row = \(indexPath.row)")
        
        
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell.delegate = self
            
            previewCell.configure(id: idPreview, poster: posterPreview as! [UIImage], titleImage: titleImagePreview as! [UIImage])
            
            cell = previewCell
        case 1:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie as! [UIImage])
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")

            
            //되는 url
//            let url = URL(string: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/videoplayback.mp4")
            
            // 안되는 url
            let url = URL(string: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/videoplaybac")
            
            
            if let videoCell = tableView.dequeueReusableCell(withIdentifier: VideoAdvertisementTableViewCell.identifier) as? VideoAdvertisementTableViewCell {
                // 재사용 cell 있는가??
                videoCell.delegate = self
                
                videoCell.configure(/*advertisement: url, */contentID: 1234, contentName: "고양이의 장난", dibs: false)
                
                cell = videoCell
            } else { // 최초 호출
               videoAdvertismentCell = VideoAdvertisementTableViewCell(style: .default, reuseIdentifier: VideoAdvertisementTableViewCell.identifier, url: url)
                
                videoAdvertismentCell?.delegate = self
                
                
                videoAdvertismentCell?.configure(/*advertisement: url, */contentID: 1234, contentName: "고양이의 장난", dibs: false)
                
                
                cell = videoAdvertismentCell!
            }
            
        case 3:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            watchContentCell.configure(poster: posterWatch as! [UIImage], watchTime: watchTimekWatch, playMark: playMark/*, url: <#T##URL#>*/)
            
            cell = watchContentCell
            
        case 4:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            top10Cell.delegate = self
            top10Cell.configure(id: idTop10, poster: posterTop10 as! [UIImage])
            cell = top10Cell
            
        default:
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            cell = UITableViewCell()
        }
        
        
        return cell
    }
    
    
    
}

//MARK: - PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    // 상민 수정부분(04.13일| 17:21분)
    
    func selectCell() {
        print("PreViewController 미리보기 cell 클릭")
        let previewVC = PreViewController()
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: true)
    }
    
    
}

//MARK: - LatestMoview Delegate
extension HomeViewController: LatestMovieTableViewCellDelegate {
    func didTabLatestMovieCell() {
        let contentVC = ContentViewController()
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - Top10 Delegate
extension HomeViewController: Top10TableViewCellDelegate {
    func didTabTop10Cell() {
        let contentVC = ContentViewController()
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - WatchContentCell Delegate
extension HomeViewController: WatchContentsTableViewDelegate {
    func didTabWatchContentCell() {
        print("WatchContentCell Click")
    }
    
    
}

//MARK: - VideoAdvertisemntTableViewCellDelegate
extension HomeViewController: VideoAdvertisementTableViewCellDelegate {
    
    func didTabVideoView() {
        let contentVC = ContentViewController()
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    func didTabPlayButton() {
        print("영상재생화면 이동")
    }
    
    func didTabDibsButton() {
        print("찜한 목록 추가하기")
    }
    
    
    
}
