//
//  ContentViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ContentViewController: CanSaveViewController {
    
    private let bluredBackgroundView = BluredBackgroundView()
    private let contentTableView = UITableView()
    
    private var contentId: Int
    private var content: ContentDetail?
    private var similarContents: [SimilarContent] = []
    
    init(id: Int = 3) {
        self.contentId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        request(id: contentId)
        setUI()
        setConstraints()
    }
    
    private func setNavigation() {
        // NavigationBar 투명하게 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let dismiss = UIButton(frame: CGRect(x: 0, y: 0, width: CGFloat.dynamicXMargin(margin: 5), height: CGFloat.dynamicXMargin(margin: 5)))
        dismiss.setImage(UIImage(named: "close"), for: .normal)
        dismiss.tintColor = .black
        dismiss.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
        let dismissButton = UIBarButtonItem(customView: dismiss)
        
        if navigationController?.viewControllers.first != self {
            let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .plain, target: self, action: #selector(backButtonDidTap))
            backButton.tintColor = .setNetfilxColor(name: .white)
            navigationItem.leftBarButtonItem = backButton
        }
        
        navigationItem.rightBarButtonItem = dismissButton
        
    }
    
    @objc private func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: 서버에 요청해서 데이터 받음
    private func request(id: Int) {
        guard let profileID = LoginStatus.shared.getProfileID(), let url = APIURL.defaultURL.makeURL(
            pathItems: [PathItem(name: "profiles", value: "\(profileID)"),
                        PathItem(name: "contents", value: "\(id)")]), // 컨텐츠 아이디
            let token = LoginStatus.shared.getToken()
            else { return }
        APIManager().request(url: url, method: .get, token: token) { (result) in
            switch result {
            case .success(let data):
                if let contentModel = try? JSONDecoder().decode(ContentModel.self, from: data) {
                    self.content = contentModel.content
                    self.similarContents = contentModel.similarContents
                    self.contentTableView.reloadData()
                    self.bluredBackgroundView.configure(backgroundImage: contentModel.content.contentsImage)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUI() {
        view.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.separatorStyle = .none
        contentTableView.contentInsetAdjustmentBehavior = .never
        contentTableView.backgroundView = bluredBackgroundView
        contentTableView.allowsSelection = false
        contentTableView.showsVerticalScrollIndicator = false
        
        contentTableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        contentTableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
        contentTableView.register(StaffTableViewCell.self, forCellReuseIdentifier: StaffTableViewCell.identifier)
//                contentTableView.register(ButtonsTableViewCell.self, forCellReuseIdentifier: ButtonsTableViewCell.identifier)
        contentTableView.register(RecommendedTableViewCell.self, forCellReuseIdentifier: RecommendedTableViewCell.identifier)
    }
    
    private func setConstraints() {
        contentTableView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as! PosterTableViewCell
            cell.delegate = self
            if let content = self.content {
                cell.configure(
                    posterImageName: content.contentsImage,
                    releaseYear: content.contentsPublishingYear,
                    ageGroup: content.contentsRating,
                    runningTime: content.contentsLength)
            }
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
            if let content = self.content {
                cell.configure(summary: content.contentsSummay)
            }
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: StaffTableViewCell.identifier, for: indexPath) as! StaffTableViewCell
            if let content = self.content {
                cell.configure(actor: content.actors, director: content.directors)
            }
            return cell
        } else if indexPath.row == 3{
            let returnCell: ButtonsTableViewCell
            if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonsTableViewCell.identifier) as? ButtonsTableViewCell {
                returnCell = cell
            } else {
                returnCell = ButtonsTableViewCell(id: contentId, style: .default, reuseIdentifier: ButtonsTableViewCell.identifier)
            }
            
            if let content = self.content {
                returnCell.configure(dibsButtonClicked: content.isSelected, likeButtonClicked: content.isLike)
                
                print("ContentController:", content.isSelected)
                print("ContentController:", contentId)
            }
            returnCell.saveControl = self
            returnCell.delegate = self
            return returnCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedTableViewCell.identifier, for: indexPath) as! RecommendedTableViewCell 
            cell.delegate = self
            cell.configure(contents: similarContents)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.height
        
        if indexPath.row == 0 {
            // poster
            return UITableView.automaticDimension
        } else if indexPath.row == 1{
            // summary
            return UITableView.automaticDimension
        } else if indexPath.row == 2 {
            // staff
            return UITableView.automaticDimension
        } else if indexPath.row == 3 {
            // button
            return CGFloat.dynamicYMargin(margin: 70)
        } else {
            // recommend
            return height * 0.5
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = (scrollView.contentSize.height) * 0.1
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= height) {
            let percent = (scrollView.contentOffset.y / height)
            bluredBackgroundView.blackView.alpha = percent
        } else if (scrollView.contentOffset.y > height){
            bluredBackgroundView.blackView.alpha = 1
        }
    }
    
}

extension ContentViewController: RecommendedCellDalegate {
    func didTapRecommendedContents(indexPath: IndexPath) {
        
        let contentVC = ContentViewController(id: similarContents[indexPath.row].id)
        navigationController?.pushViewController(contentVC, animated: true)
        
    }
}

extension ContentViewController: PlayDelegate {
    func play() {
        presentVideoController(contentID: contentId)
    }
    
    func dismiss() {
        presentingViewController?.dismiss(animated: true)
    }
}

extension ContentViewController: IsClickedProtocol {
    
    func dibButtonIsCliked() {
        guard let profileID = LoginStatus.shared.getProfileID(), let url = URL(string: "https://netflexx.ga/profiles/\(profileID)/contents/\(contentId)/select/"),
            let token = LoginStatus.shared.getToken()
            else { return }
        APIManager().request(url: url, method: .get, token: token) { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func likeButtonIsCliked() {
        // 애니메이션 설정하고, bool 상태 서버에서 받도록 수정
        guard let profileID = LoginStatus.shared.getProfileID(), let url = URL(string:
            "https://www.netflexx.ga/profiles/\(profileID)/contents/\(contentId)/like/"),
            let token = LoginStatus.shared.getToken()
            else { return }
        APIManager().request(url: url, method: .get, token: token) { _ in }
    }
}

extension ContentViewController: SaveStatusContentControl {
    
    func control(status: SaveContentStatus) {
        
        switch status {
        case .doseNotSave:
            guard let content = self.content else { return }
            guard let imageURL = URL.safetyURL(string: content.contentsImage) else { return }
            guard let videoURL = URL.safetyURL(string: content.videoURL) else { return }
            // 비디오 영상 용량이 커서 프리뷰로 테스트 대체함
//            guard let preview = content.previewVideo, let previewURL = URL.safetyURL(string: preview) else { return }
            // 테스트 끝나면 비디오 URL로 변경 예정
            // 터미네이터 896
            // 가버나움 889
            let saveContent = SaveContent(
                contentID: content.id,
                title: content.contentsTitle,
                rating: content.contentsRating,
                summary: content.contentsSummay,
                imageURL: imageURL,
                videoURL: videoURL,
                status: .waiting)
            saveContentControl(status: status, saveContetnt: saveContent)
        default:
            guard let saveContent = SavedContentsListModel.shared.getContent(contentID: contentId) else { return }
            saveContentControl(status: status, saveContetnt: saveContent)
        }
        
    }
    
}
