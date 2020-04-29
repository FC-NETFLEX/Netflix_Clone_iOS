//
//  HomeViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


//final class HomeViewController: UIViewController {
final class HomeViewController: BaseViewController {
    
    //    weak var delegate: HomeViewControllerCategoryDelegate?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    private let homeView = HomeView()
    
    private let dibsView = DibsView()
    
    private var categoryView = CategoryView()
    var categoryNum: Int?
    
    
    
    //MARK: layout관련 CGFloat
    private let menuBarHeight: CGFloat = 90
    //MARK: MenuBar
    private let menuBar = HomeMenuBarView()
    
    //MARK: JSON 관련
    private let decoder = JSONDecoder()
    private let homeURL = URL(string: "https://www.netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 2)/contents/")
    private let dibsURL = URL(string: "https://netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 48)/contents/selects/")
    
    //MARK: HomeView 관련
    private let savedContents = SavedContentsListModel()
    private let savedWatchVideoList = SavedContentsListModel().getWatchingContentOfSavedContent()
    
    private let homeViewCellCount = 7 //5
    
    //MARK: header content
    private var homeViewTopContent = TopConent(id: 1, title: "TopContent", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", logoImageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", categories: [String](), rating: "12세 관람가", selectedFlag: false)
    
    //MARK: preview content
    
    private var homeViewPreviewContents: [PreviewContent] = [
        PreviewContent(id: 1, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video](), categories: [String](), isSelect: true),
        PreviewContent(id: 2, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video](), categories: [String](), isSelect: true),
        PreviewContent(id: 3, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video](), categories: [String](), isSelect: true),
        PreviewContent(id: 4, title: "preview", previewVideoURL: "", logoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", poster: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp", videos: [Video](), categories: [String](), isSelect: true)]
    
    
    //MARK: LatestMovie content
    private var homeViewLatestContents: [RecommendContent] = [RecommendContent(id: 1, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 2, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 3, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"), RecommendContent(id: 4, title: "최신영화", imageURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/contents/image/%EA%B0%80%EB%B2%84%EB%82%98%EC%9B%80.jp"),]
    
    
    //MARK: Top10 content
    private var homeViewTop10Contents: [Top10Content] = [Top10Content(id: 1, title: "top10", imageURL: "darkGray"), Top10Content(id: 2, title: "top10", imageURL: "darkGray"), Top10Content(id: 3, title: "top10", imageURL: "darkGray")]
    
    
    //MARK: WatchContents
    private var homeViewWatchContents: [WatchVideo] = [WatchVideo]() //[WatchVideo(id: 1, video: Video(id: 1, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 11), WatchVideo(id: 2, video: Video(id: 2, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 22), WatchVideo(id: 3, video: Video(id: 3, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 33), WatchVideo(id: 4, video: Video(id: 4, videoURL: ""), playTime: 0, videoLength: 0, poster: "darkGray", contentId: 44)]
    
    
    //MARK: ADContents
    private var homeViewADContent = ADContent(id: 1, title: "", titleEnglish: "", timeLength: "0", pubYear: "2020", previewVideoURL: "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp", selected: false)
    //"https://fc-netflex.s3.ap-northeast-2.amazonaws.com/video/preview/29_04_09_19.mp4"
    
    
    //MARK: VideoAdvertisement ->
    private var videoAdvertismentCell: VideoAdvertisementTableViewCell?
    
    private var previewCell: PreviewTableViewCell?
//    private var latestCell: LatestMovieTableViewCell?
//    private var watchCell: WatchContentsTableViewCell?
    
    //MARK: DibsView관련
    //    private var dibsViewContents
    private let dibsViewFlowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)
    private var dibsViewContents = [DibsContent]()
    
    //MARK: LifeCycle
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view = homeView
        
        print("저장 컨텐츠 \(type(of: savedWatchVideoList)) -> \(savedWatchVideoList)")
        
        //MARK: HomeViewRequest
        homeRequest()
        
        
        setUI()
        setConstraints()
    }
    

    
    //MARK: ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        if view.subviews[0] == homeView {
            self.videoAdvertismentCell?.player?.pause()
            
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("====================================")
        
//        homeView.homeTableView.reloadData()
        //x
        //        latestCell?.reloadInputViews()
        
//                latestCell?.contentsCollectionView.reloadData()
//                latestCell?.contentsCollectionView.reloadInputViews()
        //        previewCell?.previewCollectionView.reloadData()
        
        
        //        previewCell.collectionView
        //        homeView.homeTableView.cell
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
    
    //MARK: Home request
    private func homeRequest() {
        guard let token = LoginStatus.shared.getToken() else { return }
        var urlRequest = URLRequest(url: homeURL!)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { return print("jsonPassing error: ", error!)}
            guard let response = response as? HTTPURLResponse else { return print("jsonPassing response 오류") }
            guard (200..<400).contains(response.statusCode) else { return print("json response code \(response.statusCode)")}
            guard let data = data else { return print("jsonPassing data 오류") }
            
            do {
                let jsonData = try self.decoder.decode(HomeContent.self, from: data)
                print("----------------[ HomeView jsonData 파싱시작 ]--------------------")
                
                
                self.homeViewLatestContents.removeAll()
                
                self.homeViewTopContent = jsonData.topContent
                self.homeViewPreviewContents = jsonData.previewContents
                self.homeViewLatestContents = jsonData.recommendContents
                self.homeViewTop10Contents = jsonData.top10Contents
                self.homeViewWatchContents = jsonData.watchingVideo
                //                    self.homeViewWatchContents += self.savedContents.getWatchingContentOfSavedContent()
                self.homeViewADContent = jsonData.adContent
                
                self.savedWatchVideoList.forEach {
                    self.homeViewWatchContents.append($0)
                }
                
                DispatchQueue.main.sync {
                    self.homeView.homeTableView.reloadData()
                    
                }
                
                
                print("-----------------[ HomeView jsonData 파싱 종료 ]-------------------")
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    //MARK: categoryRequest
    private func categoryRequet(categoryNum: Int) {
        let url = URL(string: "https://www.netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 2)/contents/?category=\(categoryNum)")
        
        guard let token = LoginStatus.shared.getToken() else { return }
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
       
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { return print("jsonPassing error: ", error!)}
            guard let response = response as? HTTPURLResponse else { return print("jsonPassing response 오류") }
            guard (200..<400).contains(response.statusCode) else { return print("json response code \(response.statusCode)")}
            guard let data = data else { return print("jsonPassing data 오류") }
            
            do {
                let jsonData = try self.decoder.decode(HomeContent.self, from: data)
                print("----------------[ HomeView jsonData 파싱시작 ]--------------------")
                
                
                self.homeViewLatestContents.removeAll()
                
                self.homeViewTopContent = jsonData.topContent
                self.homeViewPreviewContents = jsonData.previewContents
                self.homeViewLatestContents = jsonData.recommendContents
                self.homeViewTop10Contents = jsonData.top10Contents
                self.homeViewWatchContents = jsonData.watchingVideo
                //                    self.homeViewWatchContents += self.savedContents.getWatchingContentOfSavedContent()
                self.homeViewADContent = jsonData.adContent
                
                self.savedWatchVideoList.forEach {
                    self.homeViewWatchContents.append($0)
                }
                
                DispatchQueue.main.sync {
                    self.homeView.homeTableView.reloadData()
                }
                
                
                print("-----------------[ HomeView jsonData 파싱 종료 ]-------------------")
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
}


//MARK: HomeMenuBarViewDelegate
extension HomeViewController: HomeMenuBarViewDelegate {
    func didTapMenuBarIconButton() {
        print("MenuBar DidTabIcon")
        
        homeRequest()
        
        menuBar.swingBackAnimation()
        
        if view.subviews[0] == dibsView {
            print("view dibsView")
            dibsView.removeFromSuperview()
            view.insertSubview(homeView, at: 0)
            
            homeView.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        
    }
    
    func didTapMenuBarMovieButton() {
        print("MenuBar DidTabMovie")
        menuBar.movieClickAnimation()
    }
    
    //MARK: CategoryButton
    func didTapCategoryButton() {
        
        print("MenuBar DidTabCategory")
        
        let categoryVC = CategorySelectViewController()
        categoryVC.delegate = self
        categoryVC.modalPresentationStyle = .overFullScreen
        present(categoryVC, animated: true)
    }
    
    func didTapDibsButton() {
        print("MenuBar DidTabDibs")
        
        // dibsView 화면전환
        if view.subviews[0] == homeView {
            print("subView => homeview 전환 DibsView로")
            homeView.removeFromSuperview()
            view.insertSubview(dibsView, at: 0)
            
            dibsView.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.top.equalToSuperview().inset(menuBarHeight)
            }
            
            //MARK: DibsButton Animation
            menuBar.dibsClickAnimation()
            //            menuBar.movieButton.isHidden = true
            
            
            //MARK: - dibsView Request
            if dibsViewContents.count == 0 {
                //request
                //request객체로
                
                guard let token = LoginStatus.shared.getToken() else { return }
                var urlRequest = URLRequest(url: dibsURL!)
                urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    //                let dataTask = URLSession.shared.dataTask(with: self.dibsURL!) { (data, response, error) in
                    print(" DibsView dataTask 입성")
                    
                    print("dibURL -> \(self.dibsURL)")
                    
                    guard error == nil else { return print("error:", error!) }
                    guard let response = response as? HTTPURLResponse else { return print("response 오류")}
                    guard (200..<400).contains(response.statusCode) else { return print("response statusCode \(response.statusCode) \n파싱 종료") }
                    guard let data = data else { return  print("jsonPassing data 오류") }
                    
                    do {
                        let jsonData = try self.decoder.decode([DibsContent].self, from: data)
                        print("----------------[ DibsView jsonData 파싱시작 ]--------------------")
                        self.dibsViewContents = jsonData
                        
                        DispatchQueue.main.async {
                            self.dibsView.collectionView.reloadData()
                        }
                        
                        print("----------------[ DibsView jsonData 파싱종료 ]--------------------")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                dataTask.resume()
            }
            
        }
        
        print("dibsContents count", dibsViewContents.count)
        //dibsViewContents 비어있지 않을 경우 request
        
    }
    
    
}

//MARK: - HomeViewTitleDelegate
extension HomeViewController: HomeviewTitleDelegate {
    
    //MARK: - Dibs Request (HomeHeader)
    func didTapHomeTitledibsButton(id: Int, isEnable: @escaping () -> (), disEnable: () -> (), buttonToogle: (Bool) -> ()) {
        
        print("Hometitle dibsButton Click")
        buttonToogle(homeViewTopContent.selectedFlag)
        disEnable()
        
        let url = URL(string: "https://netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 48)/contents/\(id)/select/")
        
        guard let token = LoginStatus.shared.getToken() else { return }
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //                let dataTask = URLSession.shared.dataTask(with: self.dibsURL!) { (data, response, error) in
            print(" DibsSelect dataTask 입성")
            
            print("dibsSelect url -> \(urlRequest)")
            
            guard error == nil else { return print("error:", error!) }
            guard let response = response as? HTTPURLResponse else { return print("response 오류")}
            guard (200..<400).contains(response.statusCode) else { return print("response statusCode \(response.statusCode) \n파싱 종료") }
            
            DispatchQueue.main.sync {
                if self.homeViewTopContent.selectedFlag {
                    self.homeViewTopContent.selectedFlag = false
                } else {
                    self.homeViewTopContent.selectedFlag = true
                    
                }
                
                isEnable()
            }
            
        }
        dataTask.resume()
        
    }
    

    
    
    func didTapHomeTitlePlayButton() {
        print("HomeTitle playButtonClick")
        presentVideoController(contentID: homeViewTopContent.id)
    }
    
    func didTapHomeTitleContentButton() {
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: homeViewTopContent.id))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
        
    }
    
    
    
}
//MARK: HomeView 관련 extension

//MARK: - HomeView Delegate TableView
extension HomeViewController: UITableViewDelegate {
    
    
    //MARK: ScrollView offset
    // home화면에서 scroll 내릴때 점진적으로 alpha 0 -> 1
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yCoordinate = scrollView.contentOffset.y
        
        let alphaLimit = round( view.frame.height / 2.5 )
        
        if view.subviews[0] == homeView {
            if yCoordinate <= alphaLimit && yCoordinate > 0 {
                //점차 불투명해지는 부분.
                let alpha = (1 * yCoordinate) / 300
                menuBar.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: alpha)
            } else if yCoordinate > alphaLimit {
                menuBar.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                
                menuBar.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
                
            }
            
        }
        
        
    }
    
    //MARK: -UITableViewCell willDisplay
    // Video Cell 보이려고 할때 영상 재생되게 하려고
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? VideoAdvertisementTableViewCell {
        
            videoCell.player?.play()
        }
        
        
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
            if homeViewWatchContents.count == 0 {
                return 0
            }
            return watchCellHeight
        case 5, 6:
            return posterCellHeight
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
        
        header.configure(id: homeViewTopContent.id, poster: homeViewTopContent.imageURL, categories: homeViewTopContent.categories, dibs: homeViewTopContent.selectedFlag, titleImage: homeViewTopContent.logoImageURL /*, url: URL(string: firstCellURL)*/)
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
            
            //            let previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            
            previewCell?.delegate = self
            var idPreview = [Int]()
            var posterPreview = [String]()
            var titleImagePreview = [String]()
            
            homeViewPreviewContents.forEach {
                
                idPreview.append($0.id)
                posterPreview.append($0.poster)
                titleImagePreview.append($0.logoURL)
            }
            
            previewCell?.configure(id: idPreview, posters: posterPreview, titleImages: titleImagePreview)
            
            cell = previewCell!
        case 1:
            //MARK: LatestCell
            
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
//            latestCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            let title = "최신영화"
            var idLatestMovie = [Int]()
            var posterLatestMovie = [String]()
            
            homeViewLatestContents.forEach {
                
                idLatestMovie.append($0.id)
                posterLatestMovie.append($0.imageURL)
            }
            
            
            latestMovieCell.configure(id: idLatestMovie, poster: posterLatestMovie, cellTitle: title)
            latestMovieCell.delegate = self
            cell = latestMovieCell
            
        case 2:
            //MARK: VideoCell
            
            let url = URL.safetyURL(string: homeViewADContent.previewVideoURL)
            
            videoAdvertismentCell = VideoAdvertisementTableViewCell(style: .default, reuseIdentifier: VideoAdvertisementTableViewCell.identifier, url: url)
            
            videoAdvertismentCell?.delegate = self
            
            
            videoAdvertismentCell?.configure(contentID: homeViewADContent.id, contentName: homeViewADContent.title, dibs: homeViewADContent.selected)
            
            
            cell = videoAdvertismentCell!
           
            
        case 3:
            //MARK: WatchContentCell
            let watchContentCell = tableView.dequeueReusableCell(withIdentifier: WatchContentsTableViewCell.identifier, for: indexPath) as! WatchContentsTableViewCell
            watchContentCell.delegate = self
            
            var posterWatch = [URL]()
            var watchTimekWatch = [Int]()
            var playMark = [Int]()
            var contentId = [Int]()
            
            homeViewWatchContents.forEach {
                contentId.append($0.contentId)
                playMark.append($0.playTime)
                watchTimekWatch.append($0.videoLength)
                posterWatch.append(URL(string: $0.poster)!)
            }
            
            watchContentCell.configure(poster: posterWatch, watchTime: watchTimekWatch, playMark: playMark, contentID: contentId)
            
            cell = watchContentCell
            
        case 4:
            //MARK: Top10Cell
            
            let top10Cell = tableView.dequeueReusableCell(withIdentifier: Top10TableViewCell.identifier, for: indexPath) as! Top10TableViewCell
            
            var idTop10 = [Int]()
            var posterTop10 = [String]()
            
            homeViewTop10Contents.forEach {
                
                idTop10.append($0.id)
                posterTop10.append($0.imageURL)
            }
            
            top10Cell.delegate = self
            top10Cell.configure(id: idTop10, poster: posterTop10)
            cell = top10Cell
        
    //MARK: 가데이터 셀
        case 5:
            let recommendCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            let title = "추천영화 1"
            let recommend = homeViewLatestContents.shuffled()
            var idLatestMovie = [Int]()
            var posterLatestMovie = [String]()
            
            recommend.forEach {
                
                idLatestMovie.append($0.id)
                posterLatestMovie.append($0.imageURL)
            }
            
            
            recommendCell.configure(id: idLatestMovie, poster: posterLatestMovie, cellTitle: title)
            recommendCell.delegate = self
            cell = recommendCell
        case 6:
            let recommendSecondCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.indentifier, for: indexPath) as! LatestMovieTableViewCell
            
            let title = "추천영화 2"
            let recommend = homeViewLatestContents.shuffled()
            var idLatestMovie = [Int]()
            var posterLatestMovie = [String]()
            
            recommend.forEach {
                
                idLatestMovie.append($0.id)
                posterLatestMovie.append($0.imageURL)
            }
            
            
            recommendSecondCell.configure(id: idLatestMovie, poster: posterLatestMovie, cellTitle: title)
            recommendSecondCell.delegate = self
            cell = recommendSecondCell
        default:
            
            cell = UITableViewCell()
        }
        
        
        return cell
    }
    
    
    
}



//MARK: - HomeView PreviewDelegate (미리보기 델리게이트)
extension HomeViewController: PreviewTableViewCellDelegate {
    
    func didTapPreviewCell(index: Int) {
        let previewVC = PreViewController(index: index, previews: homeViewPreviewContents)
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: true)
    }
    
}

//MARK: - HomeView LatestMoview Delegate
extension HomeViewController: LatestMovieTableViewCellDelegate {
    func didTapLatestMovieCell(id: Int) {
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: id))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
        
        
    }
    
    
}

//MARK: - HomeView Top10 Delegate
extension HomeViewController: Top10TableViewCellDelegate {
    func didTapTop10Cell(id: Int) {
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: id))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
    }
    
    
}

//MARK: - HomeView WatchContentCell Delegate
extension HomeViewController: WatchContentsTableViewDelegate {
    func didTapWatchContentInfo(contentId: Int) {
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: contentId))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
    }
    
    func didTapWatchContentPlay(contentID: Int) {
        print("WatchContentCell Click")
        print("contentId \(contentID)")
        presentVideoController(contentID: contentID)
    }
    
    
}

//MARK: - HomeView VideoAdvertisemntTableViewCellDelegate
extension HomeViewController: VideoAdvertisementTableViewCellDelegate {
    func didTapVideoCellDibsButton(id: Int, isEnable: @escaping () -> (), disEnable: () -> (), buttonToogle: (Bool) -> ()) {
        
        
        print("AD dibsButton Click")
        print("homeViewADContent.selected \(homeViewADContent.selected)")
        buttonToogle(homeViewADContent.selected)
        disEnable()
        
        let url = URL(string: "https://netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 48)/contents/\(id)/select/")
        
        guard let token = LoginStatus.shared.getToken() else { return }
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //                let dataTask = URLSession.shared.dataTask(with: self.dibsURL!) { (data, response, error) in
            print(" DibsSelect dataTask 입성")
            
            print("dibsSelect url -> \(urlRequest)")
            
            guard error == nil else { return print("error:", error!) }
            guard let response = response as? HTTPURLResponse else { return print("response 오류")}
            guard (200..<400).contains(response.statusCode) else { return print("response statusCode \(response.statusCode) \n파싱 종료") }
            
            DispatchQueue.main.sync {
                if self.homeViewADContent.selected {
                    self.homeViewADContent.selected = false
                } else {
                    self.homeViewADContent.selected = true
                    
                }
                
                isEnable()
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
    
    func didTapVideoView(contentId: Int) {
        
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: contentId))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
    }
    
    func didTapVideoCellPlayButton(contentId: Int) {
        print("영상재생화면 이동")
        presentVideoController(contentID: contentId)
    }
    
    
}

//MARK: DibsView 관련 extension

//MARK: DibsView CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dibsViewContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dibsView.collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBasicItem.identifier, for: indexPath) as! ContentsBasicItem
        
        cell.jinConfigure(urlString: dibsViewContents[indexPath.row].imageURL)
        
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


//MARK: CcategoryViewController delegate
extension HomeViewController: CategorySelectVCDelegate {
    func selectAllCategory() {
        homeRequest()
        menuBar.categoryButton.setTitle("전체 장르 ▼", for: .normal)
    }
    
    func selectCategory(categorySelectNum: Int, categoryName: String) {
        print("categorynum \(categorySelectNum)")
        
        categoryRequet(categoryNum: categorySelectNum)
        menuBar.categoryButton.setTitle("\(categoryName) ▼", for: .normal)
        
    }
    
    
    
    
}
