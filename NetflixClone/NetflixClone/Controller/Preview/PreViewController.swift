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
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var previewSubviews = [PreviewView]()
    
    private var preview: [PreviewContent]
    private var receivedPreviewIndex: Int
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    private var lastOffset: CGFloat = 0
    
    
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
        setUI()
        setConstraints()
        createPreviewSubviews()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard preview.count > 0 else { return }
        playerScrollView.setContentOffset(CGPoint(x: CGFloat(receivedPreviewIndex) * playerScrollView.bounds.width, y: 0), animated: false)
        self.previewSubviews[self.receivedPreviewIndex].player.play()
        configure(dibsButtonClicked: self.preview[receivedPreviewIndex].isSelect)
        preview.forEach {
            print("title: ", $0.title, "||", " category: ", $0.categories)
        }
    }
    
    // MARK: 뷰 사라질 때, 프리뷰 영상 정지
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.previewSubviews[self.displayingViewIndex].player.pause()
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
    }
    
    // MARK: Create ScrollView content Views
    private func createPreviewSubviews() {
        self.previewSubviews = preview.compactMap {
            guard let url = URL(string: $0.previewVideoURL) else {
                print("makeURL Fail")
                return nil
            }
            let view = PreviewView(url: url)
            view.configure(image: $0.poster)
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: view.player.currentItem)
            return view
        }
        
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
    
    // MARK: 
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
            let contentsVC = ContentViewController(id: preview[displayingViewIndex].id)
            print(preview[displayingViewIndex].title)
            print(preview[displayingViewIndex].poster)
            contentsVC.modalPresentationStyle = .fullScreen
            present(contentsVC, animated: true)
        case 2:
            print("재생 버튼 눌렀을 때 인덱스: ", displayingViewIndex)
            self.receivedPreviewIndex = displayingViewIndex
            presentVideoController(contentID: preview[displayingViewIndex].id)
        default:
            break
        }
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        let cmTime = CMTime(value: 0, timescale: 1)
        previewSubviews[displayingViewIndex].player.seek(to: cmTime)
        
        if displayingViewIndex < previewSubviews.count - 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.categoryLabel.alpha = 0
                    self.playerScrollView.contentOffset.x = CGFloat(self.displayingViewIndex + 1) * self.view.frame.width
                }, completion: { _ in
                    self.categoryLabel.alpha = 1
                    self.previewSubviews[self.displayingViewIndex].player.play()
                                        
                    self.configure(dibsButtonClicked: self.preview[self.displayingViewIndex].isSelect)
                })
            }
        } else {
            dismiss(animated: true)
        }
        
    }
    
    private func configure(dibsButtonClicked: Bool) {
        self.categoryLabel.text = preview[displayingViewIndex].genre
        self.dibsView.isClicked = dibsButtonClicked
        self.dibsView.imageView.image = dibsButtonClicked ? UIImage(systemName: "checkmark"): UIImage(systemName: "plus")
    }
}

extension PreViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        previewSubviews[displayingViewIndex].player.play()
        self.configure(dibsButtonClicked: self.preview[self.displayingViewIndex].isSelect)
        categoryLabel.alpha = 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previewSubviews.forEach {
            $0.player.pause()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let offset = scrollView.contentOffset.x
        
        let scale = scrollView.contentOffset.x / scrollView.frame.width
        var alpha: CGFloat = 0
        
        guard offset >= 0 && offset < (scrollView.contentSize.width - width) else { return }
        if lastOffset <= offset {
            alpha = 1 - abs(scrollView.contentOffset.x / scrollView.frame.width - CGFloat(displayingViewIndex))
            guard alpha < 1 else { return }
            categoryLabel.alpha = abs(alpha)
        } else {
            alpha = abs(scrollView.contentOffset.x / scrollView.frame.width - CGFloat(displayingViewIndex))
            categoryLabel.alpha = abs(alpha)
        }
        lastOffset = offset
    }
}

