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
    private let homeView = HomeView()

    private let dibsView = DibsView()
    
//MARK: layout관련 CGFloat
    private let menuBarHeight: CGFloat = 90
//MARK: MenuBar
    private let menuBar = HomeMenuBarView()
    
//MARK: JSON 관련
    private let decoder = JSONDecoder()
    private let homeURL = URL(string: "https://www.netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 2)/contents/")
    
    
//MARK: HomeView 관련
    
    //    private let homeTableView = UITableView(frame: .zero, style: .grouped)
    private let homeViewCellCount = 5
    
    //MARK: header content
    private var homeViewTopContent = TopConent(id: 1, title: "TopContent", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", logoImageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", categories: [String](), rating: "12세 관람가", selectedFlag: false)
    
    //MARK: preview content

    private var homeViewPreviewContents: [PreviewContent] = [PreviewContent(id: 1, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()), PreviewContent(id: 2, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()), PreviewContent(id: 3, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]()),PreviewContent(id: 4, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video]())]


    //MARK: LatestMovie content
    private var homeViewLatestContents: [RecommendContent] = [RecommendContent(id: 1, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 2, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 3, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 4, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"),]

    
    //MARK: Top10 content
    private var homeViewTop10Contents: [Top10Content] = [Top10Content(id: 1, title: "top10", imageURL: "darkGray"), Top10Content(id: 2, title: "top10", imageURL: "darkGray"), Top10Content(id: 3, title: "top10", imageURL: "darkGray")]

    
    //MARK: WatchContents
    private var homeViewWatchContents: [WatchVideo] = [WatchVideo(id: 1, video: Video(id: 1, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 11), WatchVideo(id: 2, video: Video(id: 2, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 22), WatchVideo(id: 3, video: Video(id: 3, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 33), WatchVideo(id: 4, video: Video(id: 4, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 44)]
    
    
    //MARK: ADContents
    private var homeViewADContent = ADContent(id: 1, title: "", titleEnglish: "", timeLength: "0", pubYear: "2020", previewVideoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp", selected: false)
    //"https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp4"

    
    //MARK: VideoAdvertisement ->
    private var videoAdvertismentCell: VideoAdvertisementTableViewCell?
    
//MARK: DibsView관련
//    private var dibsViewContents
    private let dibsViewFlowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)

    
    //MARK: LifeCycle
//    override func loadView() {
//        view = homeView
//    }
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = homeView

        //MARK: JSONPassing
        DispatchQueue.global().async {
            //            self.jsonPassing()
            print("----------------[ jsonPassing ]----------------")
            let dataTask = URLSession.shared.dataTask(with: self.homeURL!) { (data, response, error) in
                print("dataTask 입성")
                guard error == nil else { return print("jsonPassing error: ", error!)}
                guard let response = response as? HTTPURLResponse, (200..<400).contains(response.statusCode) else { return print("jsonPassing response 오류") }
                guard let data = data else { return print("jsonPassing data 오류") }

                do {
                    let jsonData = try self.decoder.decode(HomeContent.self, from: data)
                    print("----------------[ jsonData 파싱시작 ]--------------------")

                    
                    self.homeViewLatestContents.removeAll()
                    
                    self.homeViewTopContent = jsonData.topContent
                    self.homeViewPreviewContents = jsonData.previewContents
                    self.homeViewLatestContents = jsonData.recommendContents
                    self.homeViewTop10Contents = jsonData.top10Contents
                    self.homeViewWatchContents = jsonData.watchingVideo
//                    self.adContent = jsonData.adContent
                    
                    DispatchQueue.main.sync {
                        self.homeView.homeTableView.reloadData()
                    }
                    
                    print("-----------------[ jsonData 파싱 종료 ]-------------------")
                } catch {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }
    
        setUI()
        setConstraints()
    }
    
    //MARK: ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
//        if view == homeView {
//            hoeview.videoAdvertismentCell?.player?.pause()
//
//        }
        
        // VideoCell의 영상 재생 멈춤
        videoAdvertismentCell?.player?.pause()
    }
  
    
    //MARK: - UI
    private func setUI() {
        //상단 menuBar관련
        menuBar.delegate = self
        
        //HomeView 관련
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        
        //DibsView 관련
        dibsView.collectionView.delegate = self
        dibsView.collectionView.dataSource = self
        
//        homeView.addSubview(menuBar)
        view.addSubview(homeView)

        view.addSubview(menuBar)

    }
    private func setConstraints() {
        
        homeView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        menuBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(menuBarHeight)
        }
        

    }
    
    
}


//MARK: HomeMenuBarViewDelegate
extension HomeViewController: HomeMenuBarViewDelegate {
    func didTabMenuBarIconButton() {
        print("MenuBar DidTabIcon")
//        view = homeView
        if view.subviews[0] == dibsView {
            print("view dibsView")
            dibsView.removeFromSuperview()
            view.insertSubview(homeView, at: 0)
            
            homeView.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
        }
    }
    
    func didTabMenuBarMovieButton() {
        print("MenuBar DidTabMovie")
    }
    
    func didTabCategoryButton() {
        print("MenuBar DidTabCategory")
    }
    
    func didTabDibsButton() {
        print("MenuBar DidTabDibs")
//        view = dibsView
//        if view
        homeView.removeFromSuperview()
        view.insertSubview(dibsView, at: 0)
        
        dibsView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(menuBarHeight)
        }
    }
    
    
}

//MARK: HomeView 관련 extension

//MARK: - HomeView Delegate TableView
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

//MARK: - HomeView Datasource TableView
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = HomeviewTitle()
        header.delegate = self
        let poster = URL(string: homeViewTopContent.imageURL)
        let logo = URL(string: homeViewTopContent.logoImageURL)!
//        do {
//            let posterData = try Data(contentsOf: URL(string: homeViewTopContent.imageURL)!)
//            let logoData = try Data(contentsOf: URL(string: homeViewTopContent.logoImageURL)!)
//            poster = UIImage(data: posterData)!
//            logo = UIImage(data: logoData)!
//        } catch {
//            logo = UIImage(named: "darkGray")!
//            poster = UIImage(named: "")!
//        }
        
        
        header.configure(id: homeViewTopContent.id, poster: poster!, category: homeViewTopContent.categories, dibs: homeViewTopContent.selectedFlag, titleImage: logo /*, url: URL(string: firstCellURL)*/)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print("hoveVC:  Datasource cellForRowAt row = \(indexPath.row)")
        
        
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            //MARK: PreviewCell

            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell.delegate = self
            var idPreview = [Int]()
            var posterPreview = [URL]()
            var titleImagePreview = [URL]()
            
            homeViewPreviewContents.forEach {

                idPreview.append($0.id)
                posterPreview.append(URL(string: $0.poster)!)
                titleImagePreview.append(URL(string: $0.logoURL)!)
            }
            
            previewCell.configure(id: idPreview, posters: posterPreview, titleImages: titleImagePreview)
            
            cell = previewCell
        case 1:
            //MARK: LatestCell

            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            var idLatestMovie = [Int]()
            var posterLatestMovie = [String]()
            
            homeViewLatestContents.forEach {
               
                idLatestMovie.append($0.id)
                posterLatestMovie.append($0.imageURL)
            }

            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie)
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
            //MARK: VideoCell
       
            let url = URL(string: homeViewADContent.previewVideoURL)
            
            
            if let videoCell = tableView.dequeueReusableCell(withIdentifier: VideoAdvertisementTableViewCell.identifier) as? VideoAdvertisementTableViewCell {
                // 재사용 cell 있는가??
                videoCell.delegate = self
                
                videoCell.configure(/*advertisement: url, */contentID: homeViewADContent.id, contentName: homeViewADContent.title, dibs: homeViewADContent.selected)
                
                cell = videoCell
            } else { // 최초 호출
                videoAdvertismentCell = VideoAdvertisementTableViewCell(style: .default, reuseIdentifier: VideoAdvertisementTableViewCell.identifier, url: url)
                
                videoAdvertismentCell?.delegate = self
                
                
                videoAdvertismentCell?.configure(/*advertisement: url, */contentID: homeViewADContent.id, contentName: homeViewADContent.title, dibs: homeViewADContent.selected)
                
                
                cell = videoAdvertismentCell!
            }
            
        case 3:
            //MARK: WatchContentCell

            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            
            var id = [Int]()
            
            var posterWatch = [URL]()
            var watchTimekWatch = [Int]()
            var playMark = [Int]()
            var contentId = [Int]()
            
            homeViewWatchContents.forEach {
                id.append($0.id)
                contentId.append($0.contentId)
                playMark.append($0.playTime)
                watchTimekWatch.append($0.videoLength)
                posterWatch.append(URL(string: $0.poster)!)
            }
            
            watchContentCell.configure(id: id, poster: posterWatch, watchTime: watchTimekWatch, playMark: playMark, contentID: contentId/*, url: <#T##URL#>*/)
            
            cell = watchContentCell
            
        case 4:
            //MARK: Top10Cell

            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            var idTop10 = [Int]()
            var posterTop10 = [URL]()
            
            homeViewTop10Contents.forEach {
                
                idTop10.append($0.id)
                posterTop10.append(URL(string: $0.imageURL)!)
            }
            
            top10Cell.delegate = self
            top10Cell.configure(id: idTop10, poster: posterTop10)
            cell = top10Cell
            
        default:

            cell = UITableViewCell()
        }
        
        
        return cell
    }
    
    
    
}

//MARK: - HomeViewTitleDelegate
extension HomeViewController: HomeviewTitleDelegate {
    func didTabHomeTitledibsButton() {
       print("Hometitle dibsButton Click")
    }
    
    func didTabHomeTitlePlayButton() {
        print("HomeTitle playButtonClick")

    }
    
    func didTabHomeTitleContentButton() {
        let contentVC = ContentViewController(id: homeViewTopContent.id)
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    

    
}

//MARK: - HomeView PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    
    func didTabPreviewCell(index: Int) {
        let previewVC = PreViewController(index: index)
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: true)
    }
    
}

//MARK: - HomeView LatestMoview Delegate
extension HomeViewController: LatestMovieTableViewCellDelegate {
    func didTabLatestMovieCell(id: Int) {
        let contentVC = ContentViewController(id: id)
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - HomeView Top10 Delegate
extension HomeViewController: Top10TableViewCellDelegate {
    func didTabTop10Cell(id: Int) {
        let contentVC = ContentViewController(id: id)
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    
}

//MARK: - HomeView WatchContentCell Delegate
extension HomeViewController: WatchContentsTableViewDelegate {
    func didTabWatchContentInfo(contentId: Int) {
        let contentVC = ContentViewController(id: contentId)
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }

    func didTabWatchContentPlay() {
        print("WatchContentCell Click")
    }


}

//MARK: - HomeView VideoAdvertisemntTableViewCellDelegate
extension HomeViewController: VideoAdvertisementTableViewCellDelegate {
    
    func didTabVideoView(contentId: Int) {
        let contentVC = ContentViewController(id: contentId)
        contentVC.modalPresentationStyle = .fullScreen
        present(contentVC, animated: true)
    }
    
    func didTabVideoCellPlayButton() {
        print("영상재생화면 이동")
    }
    
    func didTabVideoCellDibsButton() {
        print("찜한 목록 추가하기")
    }
    
    
    
}

//MARK: DibsView 관련 extension

//MARK: DibsView CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dibsView.collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBasicItem.identifier, for: indexPath) as! ContentsBasicItem
        cell.configure(url: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EC%95%84%EC%9D%BC%EB%9D%BC.jpg")

        return cell
    }


}

//MARK: DibsView CollectionView Delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return dibsViewFlowLayout.edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dibsViewFlowLayout.linesOnScreen
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dibsViewFlowLayout.itemSpacing
    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return setDibsViewFlowLayout()
     }


    func setDibsViewFlowLayout() -> CGSize {
        let itemSpacing = dibsViewFlowLayout.itemSpacing * (dibsViewFlowLayout.itemsInLine - 1) //
        let lineSpacing = dibsViewFlowLayout.lineSpacing * (dibsViewFlowLayout.linesOnScreen - 1) // 5 * 2.5
        let horizontalInset = dibsViewFlowLayout.edgeInsets.left + dibsViewFlowLayout.edgeInsets.right
        let verticalInset = dibsViewFlowLayout.edgeInsets.top + dibsViewFlowLayout.edgeInsets.bottom

        let horizontalSpacing = itemSpacing + horizontalInset
        let verticalSpacing = lineSpacing + verticalInset

        let contentWidth = dibsView.collectionView.frame.width - horizontalSpacing
        let contentHeight = dibsView.collectionView.frame.height - verticalSpacing
        let width = contentWidth / dibsViewFlowLayout.itemsInLine
        let height = contentHeight / dibsViewFlowLayout.linesOnScreen

        return CGSize(width: width.rounded(.down), height: height.rounded(.down) - 1)
    }
}


