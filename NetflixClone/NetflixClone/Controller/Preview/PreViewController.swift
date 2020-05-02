//
//  PreViewController.swift
//  NetflixClone
//
//  Created by MyMac on 2020/04/13.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher


class PreViewController: BaseViewController {
    
    let categoryLabel = UILabel()
    let playButton = UIButton()
    private let dibsView = CustomButtonView(imageName: "plus", labelText: "내가 찜한 콘텐츠")
    private let infoView = CustomButtonView(imageName: "info.circle", labelText: "정보")
    private let dismissButton = UIButton()
    private let playerScrollView = UIScrollView()
    private var displayingViewIndex: Int {
        Int(self.playerScrollView.contentOffset.x / self.playerScrollView.bounds.width)
    }
    private lazy var top: CGFloat = UIDevice().safeTop
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var previewSubviews = [PreviewView]()
    private var logoViews = [LogoView]()
    
    // MARK: Logo Sizes
    private var bigLogoWidth: CGFloat {
        (view.frame.width * 0.5)
    }
    
    private var smallLogoWidth: CGFloat {
        (view.frame.width * 0.2)
    }
    
    private var preview: [PreviewContent]
    private var receivedPreviewIndex: Int
    
//    var player: AVPlayer!
//    var playerLayer: AVPlayerLayer!
    
    private lazy var lastOffset: CGFloat = self.playerScrollView.contentOffset.x
    
    init(index: Int = 0, previews: [PreviewContent]) {
        self.receivedPreviewIndex = index
        self.preview = previews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("privew:", #function)
        setUI()
        print("preview: Finished setUI")
        setConstraints()
        print("preview: Finished setConstraint")
        createPreviewSubviews()
        print("preview: Finished createPreviewSubviews")
        setLogoConstraints(receivedIndex: receivedPreviewIndex)
        print("preview: Finished setLogoConstraints")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("privew:", #function)
        guard preview.count > 0 else { return }
        playerScrollView.setContentOffset(CGPoint(x: CGFloat(receivedPreviewIndex) * playerScrollView.bounds.width, y: 0), animated: false)
        self.previewSubviews[self.receivedPreviewIndex].playPreview()
        configure(dibsButtonClicked: self.preview[receivedPreviewIndex].isSelect)
        preview.forEach {
            print("title: ", $0.title, "||", " category: ", $0.categories)
        }
    }
    
    // MARK: 뷰 사라질 때, 프리뷰 영상 정지
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.previewSubviews[self.displayingViewIndex].pausePreview()
    }
    
    // MARK: Set Preview UI
    private func setUI() {
        [playerScrollView, dibsView, infoView, playButton, dismissButton, categoryLabel].forEach {
            view.addSubview($0)
        }
        
        dibsView.button.tag = 0
        infoView.button.tag = 1
        playButton.tag = 2
        
        categoryLabel.font = UIFont.dynamicFont(fontSize: 13, weight: .regular)
        categoryLabel.textColor = UIColor.setNetfilxColor(name: .white)
        categoryLabel.textAlignment = .center
        
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.setTitle("▶︎ 재생", for: .normal)
        playButton.setTitleColor(UIColor.setNetfilxColor(name: .white), for: .normal)
        playButton.tintColor = .clear
        
        dibsView.label.textColor = UIColor.setNetfilxColor(name: .white)
        infoView.label.textColor = UIColor.setNetfilxColor(name: .white)
        dibsView.label.font = UIFont.dynamicFont(fontSize: 10, weight: .regular)
        infoView.label.font = UIFont.dynamicFont(fontSize: 10, weight: .regular)
        
        dibsView.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        infoView.button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = UIColor.setNetfilxColor(name: .white)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
        view.bringSubviewToFront(dismissButton)
        
        logoViews = preview.compactMap {
            let logoView = LogoView()
            logoView.configure(logoNamed: $0.logoURL)
            return logoView
        }
        
        logoViews.forEach {
            view.addSubview($0)
        }
        
        for i in (receivedPreviewIndex + 3)...(logoViews.count - 1) {
            logoViews[i].alpha = 0
        }
        
        playerScrollView.isPagingEnabled = true
        playerScrollView.delegate = self
    }
    
    // MARK: Preview AutoLayout
    private func setConstraints() {
        playerScrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
        
        let betweenLabelAndButton = CGFloat.dynamicYMargin(margin: -20)
        let buttonHeight = CGFloat.dynamicYMargin(margin: 40)
        let bottomOffset = CGFloat.dynamicYMargin(margin: -60)
        let dismissButtonSize = CGFloat.dynamicXMargin(margin: 25)
        
        categoryLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(playButton.snp.top).offset(betweenLabelAndButton)
        }
        
        playButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.snp.width).multipliedBy(0.3)
            $0.height.equalTo(buttonHeight)
            $0.bottom.equalTo(view.snp.bottom).offset(bottomOffset)
        }
        
        dibsView.snp.makeConstraints {
            $0.width.height.bottom.equalTo(playButton)
            $0.trailing.equalTo(playButton.snp.leading)
        }
        
        infoView.snp.makeConstraints {
            $0.width.height.bottom.equalTo(playButton)
            $0.leading.equalTo(playButton.snp.trailing)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view).offset(-10)
            $0.width.height.equalTo(dismissButtonSize)
        }
        
//        for (index, view) in logoViews.enumerated() {
//            let leading = index == 0 ? playerScrollView.snp.leading : logoViews[index - 1 ].snp.trailing
//
//            if index == 0 {
//                view.snp.makeConstraints {
//                    $0.top.equalTo(top)
//                    $0.leading.equalTo(leading)
//                    $0.width.equalTo(bigLogoWidth)
//                    $0.height.equalTo(view.snp.width).multipliedBy(0.6)
//                }
//            } else {
//                view.snp.makeConstraints {
//                    $0.top.equalTo(top)
//                    $0.leading.equalTo(leading)
//                    $0.width.equalTo(smallLogoWidth)
//                    $0.height.equalTo(view.snp.width).multipliedBy(0.5)
//                }
//            }
//        }
    }
    
    private func setLogoConstraints(receivedIndex: Int) {
        if receivedIndex == 0 {
            for (index, view) in logoViews.enumerated() {
                
                let leading = index == 0 ? playerScrollView.snp.leading : logoViews[index - 1 ].snp.trailing
                
                if index == 0 {
                    view.snp.makeConstraints {
                        $0.top.equalTo(top)
                        $0.leading.equalTo(leading)
                        $0.width.equalTo(bigLogoWidth)
                        $0.height.equalTo(view.snp.width).multipliedBy(0.6)
                    }
                } else {
                    view.snp.makeConstraints {
                        $0.top.equalTo(top)
                        $0.leading.equalTo(leading)
                        $0.width.equalTo(smallLogoWidth)
                        $0.height.equalTo(view.snp.width).multipliedBy(0.5)
                    }
                }
                
            }
        } else {
            for (index, view) in logoViews.enumerated() {
                
                let leading = index == 0 ? playerScrollView.snp.leading : logoViews[index - 1 ].snp.trailing
                
                if index < receivedPreviewIndex {
                    view.snp.makeConstraints {
                        $0.top.equalTo(top)
                        $0.leading.equalTo(leading)
                        $0.width.equalTo(0)
                        $0.height.equalTo(view.snp.width).multipliedBy(0.6)
                    }
                } else if index == receivedPreviewIndex {
                    view.snp.makeConstraints {
                        $0.top.equalTo(top)
                        $0.leading.equalTo(leading)
                        $0.width.equalTo(bigLogoWidth)
                        $0.height.equalTo(view.snp.width).multipliedBy(0.6)
                    }
                } else {
                    view.snp.makeConstraints {
                        $0.top.equalTo(top)
                        $0.leading.equalTo(leading)
                        $0.width.equalTo(smallLogoWidth)
                        $0.height.equalTo(view.snp.width).multipliedBy(0.5)
                    }
                }
                
            }
        }
        
    }
    
    
    // MARK: Create ScrollView content Views
    private func createPreviewSubviews() {
        
        var previews: [PreviewView] = []
        
        for (index, preview) in preview.enumerated() {
            guard let url = URL(string: preview.previewVideoURL) else {
                print("makeURL Fail")
                continue
            }
            
            let view = PreviewView(url: url, index: index)
            view.delegate = self
            view.configure(image: preview.poster)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: view.player.currentItem)
            previews.append(view)
        }
        
        self.previewSubviews = previews
        
        for (index, view) in previewSubviews.enumerated() {
            playerScrollView.addSubview(view)
            let leading = index == 0 ? playerScrollView.snp.leading : previewSubviews[index - 1].snp.trailing
            view.snp.makeConstraints {
                $0.leading.equalTo(leading)
                $0.top.bottom.width.height.equalTo(playerScrollView)
            }
            
            if index == previewSubviews.count - 1 {
                view.snp.makeConstraints {
                    $0.trailing.equalTo(playerScrollView.snp.trailing)
                }
            }
            
        }
    }
    
    // MARK: 뒤로가기 버튼
    @objc private func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: 찜하기 버튼, 평가 버튼
    @objc private func didTapButton(_ sender: UIButton) {
        var dibsButtonClicked = dibsView.isClicked
        
        switch sender.tag {
        case 0:
            // MARK: 찜하기 버튼 눌렀을 때 액션, 서버로 보내기
            if dibsButtonClicked {
                print("찜하기 버튼 클릭: ", dibsButtonClicked)
                // MARK: 눌렀을 때 애니메이션 (숫자의 크기에 따라서 도는 방향이 결정 됨)
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "checkmark")})
                
            } else {
                print("찜하기 버튼 풀기: ", dibsButtonClicked)
                // MARK: 찜하기 버튼 한번 더 눌러서 액션 풀기, 서버로 보내기
                self.dibsView.imageView.transform = .init(rotationAngle: CGFloat.pi / 2)
                UIView.transition(with: self.dibsView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.dibsView.imageView.transform = .identity
                    self.dibsView.imageView.image = UIImage(systemName: "plus")
                })
            }
            let contentId = self.preview[displayingViewIndex].id
            
            guard let profileID =  LoginStatus.shared.getProfileID(),let url = URL(string:
                "https://netflexx.ga/profiles/\(profileID)/contents/\(contentId)/select/"),
                let token = LoginStatus.shared.getToken()
                else { return }
            APIManager().request(url: url, method: .get, token: token) { _ in }
            dibsButtonClicked.toggle()
            
        // 정보버튼 눌렀을 때
        case 1:
            print("정보 버튼 눌렀을 때 인덱스: ", displayingViewIndex)
            self.receivedPreviewIndex = displayingViewIndex
            let contentVC = UINavigationController(rootViewController: ContentViewController(id: preview[displayingViewIndex].id))
            contentVC.modalPresentationStyle = .overCurrentContext
            contentVC.modalTransitionStyle = .crossDissolve
            present(contentVC, animated: true)
            print(preview[displayingViewIndex].title)
            print(preview[displayingViewIndex].poster)
        case 2:
            print("재생 버튼 눌렀을 때 인덱스: ", displayingViewIndex)
            self.receivedPreviewIndex = displayingViewIndex
            presentVideoController(contentID: preview[displayingViewIndex].id)
        default:
            break
        }
    }
    
    private func startWaitingAnimation(offset: CGFloat) {
        let width = playerScrollView.bounds.width
        let calculationForDisplayIndex = offset / width - CGFloat(displayingViewIndex)
        
        let index = offset > lastOffset ? displayingViewIndex + 1: displayingViewIndex - 1
        guard index > 0 && index < previewSubviews.count && calculationForDisplayIndex > 0 else { return }
        previewSubviews[index].isWaiting = true
    }
    
    
    private func configure(dibsButtonClicked: Bool) {
        self.categoryLabel.text = preview[displayingViewIndex].genre
        self.dibsView.isClicked = dibsButtonClicked
        self.dibsView.imageView.image = dibsButtonClicked ? UIImage(systemName: "checkmark"): UIImage(systemName: "plus")
    }
    
    private func logoMovementManager(index: Int) {
        let width = self.playerScrollView.frame.width
        let contentOffsetX = self.playerScrollView.contentOffset.x
        
        let firstLogo = logoViews[index]
        let smallLogoDelta = contentOffsetX / width - CGFloat(index)
        let bigLogoDelta = 1 - smallLogoDelta
        
        let bigWidth = bigLogoWidth * bigLogoDelta
        let smallWidth = smallLogoWidth + ((bigLogoWidth - smallLogoWidth) * smallLogoDelta)
        
        // 첫번째 큰 로고 사이즈 변경
        guard contentOffsetX >= 0, contentOffsetX <= self.playerScrollView.contentSize.width - width else { return }
        firstLogo.snp.updateConstraints({
            $0.width.equalTo(bigWidth)
        })
        
        // 두 번째 로고 사이즈 변경
        guard displayingViewIndex <= (logoViews.count - 1) - 1 else { return }
        let secondLogo = logoViews[index + 1]
        secondLogo.snp.updateConstraints({
            $0.width.equalTo(smallWidth)
        })
        
        // 로고 알파 값 변경
        guard index <= (logoViews.count - 1) - 3 else { return }
        let alpha = logoViews[displayingViewIndex].frame.size.width / bigLogoWidth
        logoViews[index].alpha = alpha
        logoViews[index + 3].alpha = 1 - alpha
        
        // 장르 레이블 알파 값 변경
        var labelAlpha: CGFloat = 0
        
        guard contentOffsetX >= 0 && contentOffsetX < (self.playerScrollView.contentSize.width - width) else { return }
        if lastOffset <= contentOffsetX {
            labelAlpha = 1 - abs(self.playerScrollView.contentOffset.x / self.playerScrollView.frame.width - CGFloat(index))
            guard labelAlpha < 1 else { return }
            categoryLabel.alpha = abs(labelAlpha)
        } else {
            labelAlpha = abs(self.playerScrollView.contentOffset.x / self.playerScrollView.frame.width - CGFloat(index))
            categoryLabel.alpha = abs(labelAlpha)
        }
        lastOffset = contentOffsetX
    }
    
}


extension PreViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        previewSubviews[displayingViewIndex].playPreview()
        self.configure(dibsButtonClicked: self.preview[self.displayingViewIndex].isSelect)
        categoryLabel.alpha = 1
//        print(scrollView.contentOffset.x)
//        print(displayingViewIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previewSubviews.forEach {
            $0.pausePreview()
        }
//        print(displayingViewIndex)
//        print(scrollView.contentOffset.x)
//        previewSubviews[displayingViewIndex].pausePreview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        startWaitingAnimation(offset: scrollView.contentOffset.x)
        logoMovementManager(index: displayingViewIndex)
        //
        //        let width = scrollView.frame.width
        //        let contentOffsetX = scrollView.contentOffset.x
        //
        //        let smallLogoDelta = contentOffsetX / width - CGFloat(displayingViewIndex)
        //        let bigLogoDelta = 1 - smallLogoDelta
        //
        //        let bigWidth = bigLogoWidth * bigLogoDelta
        //        let smallWidth = smallLogoWidth + ((bigLogoWidth - smallLogoWidth) * smallLogoDelta)
        //        let firstLogo = logoViews[displayingViewIndex]
        //
        //        var labelAlpha: CGFloat = 0
        //
        //        guard contentOffsetX >= 0, contentOffsetX <= scrollView.contentSize.width - width else { return }
        //        firstLogo.snp.updateConstraints({
        //            $0.width.equalTo(bigWidth)
        //        })
        //
        //        guard displayingViewIndex <= (logoViews.count - 1) - 1 else { return }
        //        let secondLogo = logoViews[displayingViewIndex + 1]
        //        secondLogo.snp.updateConstraints({
        //            $0.width.equalTo(smallWidth)
        //        })
        //
        //        // 알파 값 변경
        //        guard displayingViewIndex <= (logoViews.count - 1) - 3 else { return }
        //        let alpha = logoViews[displayingViewIndex].frame.size.width / bigLogoWidth
        //        logoViews[displayingViewIndex].alpha = alpha
        //        logoViews[displayingViewIndex + 3].alpha = 1 - alpha
        //
        //        guard contentOffsetX >= 0 && contentOffsetX < (scrollView.contentSize.width - width) else { return }
        //        if lastOffset <= contentOffsetX {
        //            labelAlpha = 1 - abs(scrollView.contentOffset.x / scrollView.frame.width - CGFloat(displayingViewIndex))
        //            guard labelAlpha < 1 else { return }
        //            categoryLabel.alpha = abs(labelAlpha)
        //        } else {
        //            labelAlpha = abs(scrollView.contentOffset.x / scrollView.frame.width - CGFloat(displayingViewIndex))
        //            categoryLabel.alpha = abs(labelAlpha)
        //        }
        //        lastOffset = contentOffsetX
    }
    
    
}


//MARK: PreviewViewDelegate
extension PreViewController: PreViewViewDelegate {
    
    func updateProgress(index: Int, time: Int64, duration: Float64) {
        logoViews[index].progressConfigure(currentTime: time, duration: duration)
    }
    
    // preview영상 재생끝나면 실행되는 동작
    func playerDidFinishPlaying(note: NSNotification) {
        guard displayingViewIndex < preview.count - 1 else { return }
            print("start", displayingViewIndex)

        let cmTime = CMTime(value: 0, timescale: 1)
        previewSubviews[displayingViewIndex].seekPreview(to: cmTime)
        
        if displayingViewIndex < previewSubviews.count - 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.categoryLabel.alpha = 0
                    self.playerScrollView.setContentOffset(CGPoint(x: CGFloat(self.displayingViewIndex + 1) * self.view.frame.width, y: 0), animated: true)
                }, completion: { _ in
                    self.categoryLabel.alpha = 1
                    self.previewSubviews[self.displayingViewIndex + 1].playPreview()
                    print("Completion", self.displayingViewIndex)
                    self.configure(dibsButtonClicked: self.preview[self.displayingViewIndex].isSelect)
                })
            }
        } else {
            dismiss(animated: true)
        }
        
    }
    
}
