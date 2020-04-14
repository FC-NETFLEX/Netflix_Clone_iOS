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
    
    //MARK: JSON 관련
    private var decoder = JSONDecoder()
    private var homeURL = URL(string: "https://www.netflexx.ga/profiles/2/contents/")
    
    //MARK: header content
    private var firstId = 1
    private var firstCellURL = ""
    private var firstCellPoster = ""//"titleDummy"
    private var firstCategory = [String]() //["로맨스", "한국 드라마", "드라마"]
    private var dibsFlag = false
    private var firstTitleImage = "darkGray"
    
    //MARK: preview content
    private var idPreview = [1, 2, 3, 4, 5]
    private var posterPreview = [UIImage(named: "Gray"), UIImage(named: "Gray"), UIImage(named: "Gray"), UIImage(named: "Gray"), UIImage(named: "Gray")] //[UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy"), UIImage(named: "posterDummy")]
    private var titleImagePreview = [UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray")]
    
    //MARK: LatestMovie content
    private var idLatestMovie = [1, 2, 3, 4]
    private var posterLatestMovie = [UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray")]
    
    //MARK: Top10 content
    private let idTop10 = [1, 2, 3, 4, 5]
    private let posterTop10 = [UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray")]
    
    //MARK: WatchContents
    //poster: <#T##[UIImage]#>, watchTime: T##[String], playMark: <#T##[Int64]#>, url: <#T##URL#>
    private let posterId = [1,2,3,4]
    private let posterWatch = [UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray"), UIImage(named: "darkGray")]
    private let watchTimekWatch: [Int] = [0, 0, 0, 0]
    private let playMark: [Int] = [0, 0, 0, 0]
    
    //MARK: ADContents
    private let adVideoURL = "" //"https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp4"
    
    //MARK: VideoAdvertisement ->
    private var videoAdvertismentCell: VideoAdvertisementTableViewCell?
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: JSONPassing
        DispatchQueue.global().sync {
            //            self.jsonPassing()
            print("--------jsonPassing----------------")
            let dataTask = URLSession.shared.dataTask(with: self.homeURL!) { (data, response, error) in
                print("dataTask 입성")
                guard error == nil else { return print("jsonPassing error: ", error!)}
                guard let response = response as? HTTPURLResponse, (200..<400).contains(response.statusCode) else { return print("jsonPassing response 오류") }
                guard let data = data else { return print("jsonPassing data 오류") }
                
                do {
                    let jsonData = try self.decoder.decode(HomeContent.self, from: data)
                    print("jsonData 파싱완료")
                    print("jsonData = \(jsonData)")
                    
                    
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }
    
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
//        print("=============================================================")
//        print("\n HomeViewController: TableViewCell willdisplay -> VideoCell!!!!!!!! \n")
//
        videoCell.player?.play()
        
    }
    
    //MARK: -UITableViewCell didEndDisplaying
    // Video Cell 사용안할 때 영상 멈추게 하려고
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoAdvertisementTableViewCell else { return }
//        print("=============================================================")
//        print("\n HomeViewController: TableViewCell didEndDisplayin -> VideoCell!!!!!!!! \n")
//
        videoCell.player?.pause()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        print("homeVC: -> heightForRowAt")
        
        let previewCellHeight: CGFloat = tableView.frame.height / 4
        let posterCellHeight: CGFloat = tableView.frame.height / 4 + 30
        let watchCellHeight: CGFloat = tableView.frame.height / 3
        let videoAdvertiseHeight: CGFloat = round(tableView.frame.height / 2.5)
        
        switch indexPath.row {
        case 0:
//            print("cell.row \(indexPath.row), cellHeight: \(previewCellHeight)")
            return previewCellHeight
        case 1, 4:
//            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return posterCellHeight
        case 2:
//            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
            return videoAdvertiseHeight
        case 3:
//            print("cell.row \(indexPath.row), cellHeight: \(posterCellHeight)")
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
        header.configure(id: firstId, poster: UIImage(named: firstCellPoster), category: firstCategory, dibs: dibsFlag, titleImage: UIImage(named: "darkGray"), url: URL(string: firstCellURL))
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print("hoveVC:  Datasource cellForRowAt row = \(indexPath.row)")
        
        
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell.delegate = self
            
            previewCell.configure(id: idPreview, poster: posterPreview as! [UIImage], titleImage: titleImagePreview as! [UIImage])
            
            cell = previewCell
        case 1:
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie as! [UIImage])
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")

            
            //되는 url
//            let url = URL(string: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/videoplayback.mp4")
            
            // 안되는 url
            let url = URL(string: adVideoURL)
            
            
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
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            watchContentCell.configure(poster: posterWatch as! [UIImage], watchTime: watchTimekWatch, playMark: playMark/*, url: <#T##URL#>*/)
            
            cell = watchContentCell
            
        case 4:
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            top10Cell.delegate = self
            top10Cell.configure(id: idTop10, poster: posterTop10 as! [UIImage])
            cell = top10Cell
            
        default:
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            cell = UITableViewCell()
        }
        
        
        return cell
    }
    
    
    
}

//MARK: - PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    // 상민 수정부분(04.13일| 17:21분)
    
    func selectCell() {
//        print("PreViewController 미리보기 cell 클릭")
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
