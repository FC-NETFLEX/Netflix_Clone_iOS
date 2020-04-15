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
    private let decoder = JSONDecoder()
    private let homeURL = URL(string: "https://www.netflexx.ga/profiles/2/contents/")
    
    //MARK: header content
    private var topContent = TopConent(id: 1, title: "TopContent", imageURL: "", logoImageURL: "darkGray", categories: [String](), rating: "12세 관람가", selectedFlag: false)
    
    //MARK: preview content

    private var previewContents: [PreviewContent] = [PreviewContent(id: 1, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()), PreviewContent(id: 2, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()), PreviewContent(id: 3, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()),PreviewContent(id: 4, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]())]


    //MARK: LatestMovie content
    private var latestContents: [RecommendContent] = [RecommendContent(id: 1, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 2, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 3, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 4, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"),]

    
    //MARK: Top10 content
    private var top10Contents: [Top10Content] = [Top10Content(id: 1, title: "top10", imageURL: "darkGray"), Top10Content(id: 2, title: "top10", imageURL: "darkGray"), Top10Content(id: 3, title: "top10", imageURL: "darkGray")]

    
    //MARK: WatchContents
    private var watchContents: [WatchVideo] = [WatchVideo(id: 1, video: Video(id: 1, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 11), WatchVideo(id: 2, video: Video(id: 2, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 22), WatchVideo(id: 3, video: Video(id: 3, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 33), WatchVideo(id: 4, video: Video(id: 4, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 44)]
    
    
    //MARK: ADContents
    private var adContent = ADContent(id: 1, title: "", titleEnglish: "", timeLength: "0", pubYear: "2020", previewVideoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp", selected: false)
    //"https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp4"

    
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
                    print("----------------jsonData 파싱완료--------------------")
                    print("jsonData = \(jsonData)")
                    
                    print("--------------------jsonData--------------------\n",jsonData.recommendContents)
                    
                    self.latestContents.removeAll()
                    
                    self.latestContents = jsonData.recommendContents
                    self.previewContents = jsonData.previewContents

                    
                    DispatchQueue.main.sync {
                        self.homeTableView.reloadData()
                    }
                    
                    print("-----------------jsonData 파싱 종료-------------------")
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

        videoCell.player?.play()
        
    }
    
    //MARK: -UITableViewCell didEndDisplaying
    // Video Cell 사용안할 때 영상 멈추게 하려고
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoAdvertisementTableViewCell else { return }

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
            return previewCellHeight
        case 1, 4:
            return posterCellHeight
        case 2:
            return videoAdvertiseHeight
        case 3:
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
        header.configure(id: topContent.id, poster: UIImage(named: topContent.imageURL), category: topContent.categories, dibs: topContent.selectedFlag, titleImage: UIImage(named: topContent.logoImageURL) /*, url: URL(string: firstCellURL)*/)
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
            //MARK: PreviewCell
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell.delegate = self
            var idPreview = [Int]()
            var posterPreview = [UIImage]()
            var titleImagePreview = [UIImage]()
            
            previewContents.forEach {
         
                do {
                    let posterData = try Data(contentsOf: URL(string: $0.poster)!)
                    let logoData = try? Data(contentsOf: URL(string: $0.logoURL)!)
                    posterPreview.append(UIImage(data: posterData) ?? UIImage(named: "Gray")!)
                    titleImagePreview.append(UIImage(data: logoData!) ?? UIImage(named: "darkGray")!)
                } catch {
                    posterPreview.append(UIImage(named: "Gray")!)
                    titleImagePreview.append(UIImage(named: "darkGray")!)
                }
                
                idPreview.append($0.id)
            }
            
            previewCell.configure(id: idPreview, posters: posterPreview, titleImages: titleImagePreview)
            
            cell = previewCell
        case 1:
            //MARK: LatestCell
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            var idLatestMovie = [Int]()
            var posterLatestMovie = [UIImage]()
            
            latestContents.forEach {
                do {
                    let data = try Data(contentsOf: URL(string: $0.imageURL)!)
                    posterLatestMovie.append(UIImage(data: data)!)
                } catch {
                    posterLatestMovie.append(UIImage(named: "darkGray")!)
                }
                
                idLatestMovie.append($0.id)
            }

            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie as! [UIImage])
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
            //MARK: VideoCell
            print("------------------------------------\n")
            print("HomeVC: cell Row -> \(indexPath.row)")
            

//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")

            
            
            let url = URL(string: adContent.previewVideoURL)
            
            
            if let videoCell = tableView.dequeueReusableCell(withIdentifier: VideoAdvertisementTableViewCell.identifier) as? VideoAdvertisementTableViewCell {
                // 재사용 cell 있는가??
                videoCell.delegate = self
                
                videoCell.configure(/*advertisement: url, */contentID: adContent.id, contentName: adContent.title, dibs: adContent.selected)
                
                cell = videoCell
            } else { // 최초 호출
                videoAdvertismentCell = VideoAdvertisementTableViewCell(style: .default, reuseIdentifier: VideoAdvertisementTableViewCell.identifier, url: url)
                
                videoAdvertismentCell?.delegate = self
                
                
                videoAdvertismentCell?.configure(/*advertisement: url, */contentID: adContent.id, contentName: adContent.title, dibs: adContent.selected)
                
                
                cell = videoAdvertismentCell!
            }
            
        case 3:
            //MARK: WatchContentCell
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            
            var posterWatch = [UIImage]()
            var watchTimekWatch = [Int]()
            var playMark = [Int]()
            
            watchContents.forEach {
                posterWatch.append(UIImage(named: $0.poster)!)
                watchTimekWatch.append($0.videoLength)
                playMark.append($0.playTime)
            }
            
            watchContentCell.configure(poster: posterWatch as! [UIImage], watchTime: watchTimekWatch, playMark: playMark/*, url: <#T##URL#>*/)
            
            cell = watchContentCell
            
        case 4:
            //MARK: Top10Cell
//            print("------------------------------------\n")
//            print("HomeVC: cell Row -> \(indexPath.row)")
            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            var idTop10 = [Int]()
            var posterTop10 = [UIImage]()
            
            top10Contents.forEach {
                idTop10.append($0.id)
                posterTop10.append(UIImage(named: $0.imageURL)!)
            }
            
            
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
    func selectCell(index: Int) {
        let previewVC = PreViewController(index: index)
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: true)
    }
}

//MARK: - LatestMoview Delegate
extension HomeViewController: LatestMovieTableViewCellDelegate {
    func didTabLatestMovieCell(id: Int) {
//        let contentVC = ContentViewController()
        let contentVC = ContentViewController(id: id)
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
