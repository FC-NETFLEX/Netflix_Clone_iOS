//
//  VideoView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol VideoViewDelegate: class {
    func exitAction()
    
    func biganTracking(time: Int64)
    
    func changeTracking(time: Int64) -> UIImage?
    
    func endTracking(time: Int64)
    
    func play()
    
    func pause()
    
    func step(time: Int64)
    

}


class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
}





class VideoView: UIView {
    
    weak var delegate: VideoViewDelegate?
    
    private var isControlAppear = true {
        didSet {
            if self.isControlAppear {
                appearControlView()
            } else {
                disAppearControlView()
            }
        }
    }
    
    var isLoading = true {
        didSet {
            if self.isLoading {
                startLoading()
            } else {
                finishedLoading()
            }
        }
    }
    
    private var isPlaying = true {
        didSet {
//            playButtonBackgroundView.setPlaying(self.isPlaying)
            if self.isPlaying {
                playAction()
            } else {
                pauseAction()
            }
        }
    }
//    private let testButton = PlayPauseButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let animationDuration = 0.2
    
    private var lastActionTime = Date()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let backgroundView = UIView()
    
    private let topView = UIView()
    private let exitButton = UIButton()
    private let titleLabel = UILabel()
    
    private let centerView = UIView()
    
//    private let rewindButtonBackgroundView = PlayPauseButton()
    private let rewindButtonImageView = UIImageView()
    private let rewindButton = UIButton()
    private let rewindButtonLabel = UILabel()
    private let rewindInsideView = CircleView()
    private let rewindButtonActionLabel = UILabel()
    
    private let slipButtonImageView = UIImageView()
    private let slipButtonLabel = UILabel()
    private let slipButton = UIButton()
    private let slipInsideView = CircleView()
    private let slipButtonActionLabel = UILabel()
    
    
    private let playButton = UIButton()
    private let playButtonBackgroundView = UIView()
    private let playButtonImageView = UIImageView()
    
    private let bottomView = UIView()
    private let playSlider = UISlider()
    private let restTimeLabel = UILabel()
    
    private let seekPointImageView = UIImageView()
    private let seekPointTimeLabel = UILabel()
    private let seekPointView = UIView()
    
    
    init(title: String) {
        super.init(frame: .zero)
        setUI(title: title)
        setConstraints()
        setGestureRecognizer()
        
//        test()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    
    private func setUI(title: String) {
        
        
        [backgroundView, topView, centerView, bottomView, seekPointView, loadingIndicator].forEach({
            self.addSubview($0)
        })
        
        [titleLabel, exitButton].forEach({
            topView.addSubview($0)
        })
        
        [rewindButton, slipButton, playButtonBackgroundView].forEach({
            centerView.addSubview($0)
        })
        
        [slipButtonActionLabel, slipButtonLabel, slipButtonImageView, slipInsideView].forEach({
            slipButton.addSubview($0)
        })
        
        [rewindButtonActionLabel, rewindButtonLabel, rewindButtonImageView, rewindInsideView].forEach({
            rewindButton.addSubview($0)
        })
        
        [playButtonImageView, playButton].forEach({
            playButtonBackgroundView.addSubview($0)
        })
        
        [playSlider, restTimeLabel].forEach({
            bottomView.addSubview($0)
        })
        
        [seekPointTimeLabel, seekPointImageView].forEach({
            seekPointView.addSubview($0)
        })
        
        let controlFont = UIFont.dynamicFont(fontSize: 16, weight: .regular)
        
        loadingIndicator.hidesWhenStopped = true
        isLoading = true
        autoDisappeareControlView()
        
        seekPointView.isHidden = true
        
        seekPointTimeLabel.textAlignment = .center
        seekPointTimeLabel.textColor = .setNetfilxColor(name: .white)
        
        seekPointImageView.backgroundColor = .setNetfilxColor(name: .black)
        
        backgroundView.backgroundColor = .setNetfilxColor(name: .black)
        backgroundView.alpha = 0.5
        
        titleLabel.text = title
        titleLabel.textColor = .setNetfilxColor(name: .white)
        
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = .setNetfilxColor(name: .white)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchDown)
        
        playButtonImageView.image = UIImage(systemName: "pause.fill")
        playButtonImageView.tintColor = .setNetfilxColor(name: .white)
        
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        rewindButton.addTarget(self, action: #selector(didTapRewindButton), for: .touchUpInside)
        
        rewindButtonImageView.image = UIImage(named: "rewind.png")
        rewindButtonImageView.contentMode = .scaleAspectFill
        rewindButtonImageView.tintColor = .setNetfilxColor(name: .white)
        
        rewindButtonLabel.text = "10"
        rewindButtonLabel.font = controlFont
        rewindButtonLabel.textAlignment = .center
        rewindButtonLabel.textColor = .setNetfilxColor(name: .white)
        
        rewindInsideView.backgroundColor = .setNetfilxColor(name: .white)
        rewindInsideView.alpha = 0
        
        rewindButtonActionLabel.textColor = .setNetfilxColor(name: .white)
        rewindButtonActionLabel.text = "-"
        rewindButtonActionLabel.alpha = 0
        
        slipButton.addTarget(self, action: #selector(didTapSlipButton), for: .touchUpInside)
        
        slipButtonImageView.image = UIImage(named: "slip.png")
        slipButtonImageView.tintColor = .setNetfilxColor(name: .white)
        slipButtonImageView.contentMode = .scaleToFill
        
        slipInsideView.backgroundColor = .setNetfilxColor(name: .white)
        slipInsideView.alpha = 0
        
        slipButtonLabel.text = "10"
        slipButtonLabel.font = controlFont
        slipButtonLabel.textAlignment = .center
        slipButtonLabel.textColor = .setNetfilxColor(name: .white)
        
        slipButtonActionLabel.textColor = UIColor.setNetfilxColor(name: .white)
        slipButtonActionLabel.text = "+"
        slipButtonActionLabel.alpha = 0
        
        playSlider.minimumValue = 0
        playSlider.thumbTintColor = .setNetfilxColor(name: .netflixRed)
        playSlider.minimumTrackTintColor = .setNetfilxColor(name: .netflixRed)
        playSlider.maximumTrackTintColor = .setNetfilxColor(name: .netflixLightGray)
        playSlider.addTarget(self, action: #selector(valueChangedPlaySlider(_:)), for: .valueChanged)
        playSlider.addTarget(self, action: #selector(beginTrackingPlaySlider(_:)), for: .touchDown)
        playSlider.addTarget(self, action: #selector(endTrackingPlaySlider(_:)), for: .touchUpInside)
        playSlider.addTarget(self, action: #selector(endTrackingPlaySlider(_:)), for: .touchUpOutside)
        playSlider.addTarget(self, action: #selector(endTrackingPlaySlider(_:)), for: .touchCancel)
        playSlider.setThumbImage(UIImage(), for: .normal)
        playSlider.setThumbImage(UIImage(), for: .highlighted)
        
        
        restTimeLabel.textColor = .setNetfilxColor(name: .white)
        restTimeLabel.font = .dynamicFont(fontSize: 14, weight: .bold)
        restTimeLabel.text = "00:00"
        
        
//        testButton.addTarget(self, action: #selector(test), for: .touchUpInside)
//        playButtonBackgroundView.backgroundColor = .black
        
    }
    
    private func setConstraints() {
        
        let yMargin: CGFloat = .dynamicXMargin(margin: 16)
        let xMargin: CGFloat = .dynamicYMargin(margin: 32)
        let restTimeLabelLeadingMargin: CGFloat = .dynamicYMargin(margin: 16)
        
        loadingIndicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        backgroundView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        topView.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(exitButton)
        })
        
        exitButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-xMargin)
            $0.bottom.equalToSuperview()
        })
        
        centerView.snp.makeConstraints({
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        })
        
        playButtonBackgroundView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(playButtonBackgroundView.snp.height)
        })
        
        playButtonImageView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        playButton.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        rewindButton.snp.makeConstraints({
            $0.centerX.equalToSuperview().multipliedBy(0.5)
            $0.width.equalTo(rewindButton.snp.height)
            $0.top.bottom.equalToSuperview()
        })
        
        rewindButtonActionLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        rewindButtonLabel.snp.makeConstraints({
            $0.centerX.equalTo(rewindButtonImageView)
            $0.centerY.equalTo(rewindButtonImageView)
            $0.width.equalTo(rewindButtonImageView).multipliedBy(0.9)
            $0.height.equalTo(rewindButtonLabel.snp.width)
        })
        
        rewindButtonImageView.snp.makeConstraints({
            $0.top.leading.bottom.trailing.equalToSuperview()
        })
        
        rewindInsideView.snp.makeConstraints({
            $0.top.leading.bottom.trailing.equalToSuperview()
        })
        
        slipButton.snp.makeConstraints({
            $0.centerX.equalToSuperview().multipliedBy(1.5)
            $0.width.equalTo(slipButton.snp.height)
            $0.top.bottom.equalToSuperview()
        })
        
        slipButtonActionLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        slipButtonLabel.snp.makeConstraints({
            $0.centerX.equalTo(slipButtonImageView)
            $0.centerY.equalTo(slipButtonImageView)
            $0.width.equalTo(slipButtonImageView).multipliedBy(0.9)
            $0.height.equalTo(slipButtonLabel.snp.width)
        })
        
        slipButtonImageView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        slipButton.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().multipliedBy(1.5)
        })
        
        slipInsideView.snp.makeConstraints({
            $0.leading.top.trailing.bottom.equalToSuperview()
        })
        
        bottomView.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        })
        
        playSlider.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(xMargin)
        })
        restTimeLabel.snp.makeConstraints({
            $0.centerY.equalTo(playSlider.snp.centerY)
            $0.leading.equalTo(playSlider.snp.trailing).offset(restTimeLabelLeadingMargin)
            $0.trailing.equalToSuperview().offset(-xMargin)
        })
        
        seekPointTimeLabel.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        seekPointImageView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(seekPointTimeLabel.snp.top).offset(-yMargin)
        })
        
        seekPointView.snp.makeConstraints({
            $0.width.equalToSuperview().multipliedBy(0.35)
            $0.height.equalTo(seekPointView.snp.width).multipliedBy(0.6)
            $0.centerY.equalToSuperview()
        })
        
        
        
    }
    
    
    //MARK: Gesture Recognize
    
    // 제스처 등록
    private func setGestureRecognizer() {
        
        let tapGeture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGeture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGeture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        tapGeture.require(toFail: doubleTapGesture)
    }
    
    // 더블탭 제스처의 처리
    @objc private func didDoubleTapView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let point = location.x
        let guide = bounds.width / 2
        if point >= guide {
            didTapSlipButton()
        } else {
            didTapRewindButton()
        }
    }
    
    // 탭 제스처의 처리
    @objc private func didTapView(_ gesture: UITapGestureRecognizer) {
        isControlAppear.toggle()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        autoDisappeareControlView()
        return hitView
    }
    
    
    //MARK: Action
    
    // 모든 터치 동작에 대해 일정 시간동안 아무것도 안하면 컨트롤화면이 사라지게하는 함수
    private func autoDisappeareControlView() {
        lastActionTime = Date()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                    [weak self] in
                    
                    guard let self = self else { return }
                    let currentTime = Date()
                    let dateInterval = DateInterval(start: self.lastActionTime, end: currentTime)
                    let timeInterval = dateInterval.duration
                    guard timeInterval >= 9 && self.playSlider.state.rawValue != 1 else {
                        return
                    }
                    self.isControlAppear = false
                })
    }
    
    
    // 최초 playSlider의 maximum 값과 현재 재생 구간을 설정
    func setDefaultSlider(timeRange: Int64, currentTime: Int64) {
        playSlider.maximumValue = Float(timeRange)
        playSlider.value = Float(currentTime)
        restTimeLabel.text = replaceIntWithTimeString(second: timeRange)
        playSlider.setThumbImage(nil, for: .normal)
        playSlider.setThumbImage(nil, for: .highlighted)
        playSlider.thumbTintColor = .setNetfilxColor(name: .netflixRed)
    }
    
    // 재생되면서 바뀌는 시간값을 뷰에 업데이트
    func updateTimeSet(currentTime: Int64, restTime: Int64) {
        playSlider.value = Float(currentTime)
        restTimeLabel.text = replaceIntWithTimeString(second: restTime)
    }
    
    // playSlider의 thumb의 center를 반환
    private func getThumbCenterX(sender: UISlider) -> CGFloat {
        let rect = sender.thumbRect(forBounds: sender.frame, trackRect: sender.trackRect(forBounds: sender.frame), value: sender.value)
        let gap = (rect.maxX - rect.minX) / 2
        let center = rect.minX + gap
        return center
    }
    
    // playSlider의 움직임에 맞춰서 seekPointView의 위치를 지정
    private func setSeekPointViewFrame(center: CGFloat) {
        
        let minX = center - (seekPointImageView.frame.width / 2)
        let maxX = center + (seekPointImageView.frame.width / 2)
        let xMargin = CGFloat.dynamicYMargin(margin: 16)
        let guideLineLeft = safeAreaInsets.left + xMargin
        let guideLineRight = frame.width - safeAreaInsets.right - xMargin
        
        if minX <=  guideLineLeft {
            seekPointView.center.x = guideLineLeft + (seekPointView.bounds.width / 2)
        } else if maxX >= guideLineRight{
            seekPointView.center.x = guideLineRight - (seekPointView.bounds.width / 2)
        } else {
            seekPointView.center.x = center
        }
        
        
        seekPointView.isHidden = false
    }
    
    // playSlider의 움직에 맞춰 시간레이블 세팅
    private func configureSeekPontView(value: Int64) {
        seekPointTimeLabel.text = replaceIntWithTimeString(second: value)
        let image = delegate?.changeTracking(time: value)
        seekPointImageView.image = image
    }
    
    // 썸네일 이미지 세팅
    func configureSeekPointImageView(image: UIImage) {
        DispatchQueue.main.async {
            self.seekPointImageView.image = image
        }
    }
    
    private func beginTrackingAnimation() {
        UIView.animate(withDuration: animationDuration, animations: {
            [weak self] in
            self?.topView.alpha = 0
            self?.centerView.alpha = 0
        }, completion: { [weak self] _ in
            self?.topView.isHidden = true
            self?.centerView.isHidden = true
        })
    }
    
    private func endTrackingAnimation() {
        topView.isHidden = false
        centerView.isHidden = false
        UIView.animate(withDuration: animationDuration, animations: {
            [weak self] in
            self?.topView.alpha = 1
            self?.centerView.alpha = 1
        })
    }
    
    // playSlider의 tracking 시작
    @objc private func beginTrackingPlaySlider(_ sender: UISlider) {
        let value = Int64(sender.value)
        beginTrackingAnimation()
        configureSeekPontView(value: value)
        delegate?.biganTracking(time: value)
        setSeekPointViewFrame(center: getThumbCenterX(sender: sender))
    }
    
    // playSlider의 tracking에 따라 바뀌는 값에대한 처리
    @objc private func valueChangedPlaySlider(_ sender: UISlider) {
        let value = Int64(sender.value)
        configureSeekPontView(value: value)
        setSeekPointViewFrame(center: getThumbCenterX(sender: sender))
    }
    
    // playSlider의 tracking 끝
    @objc private func endTrackingPlaySlider(_ sender: UISlider) {
        autoDisappeareControlView()
        let value = Int64(sender.value)
        endTrackingAnimation()
        seekPointView.isHidden = true
        isPlaying = true
        delegate?.endTracking(time: value)
    }
    
    // 컨트롤하는 뷰들이 나타나는 처리
    private func appearControlView() {
        topView.isHidden = false
        centerView.isHidden = false
        bottomView.isHidden = false
        backgroundView.isHidden = false
        UIView.animate(withDuration: animationDuration, animations: {
            [weak self] in
            self?.topView.alpha = 1
            self?.centerView.alpha = 1
            self?.bottomView.alpha = 1
            self?.backgroundView.alpha = 0.5
        })
    }
    
    // 컨트롤 하는 뷰들이 사라지는 처리
    private func disAppearControlView() {
        UIView.animate(withDuration: animationDuration, animations: {
            [weak self] in
            self?.topView.alpha = 0.1
            self?.centerView.alpha = 0.1
            self?.bottomView.alpha = 0.1
            self?.backgroundView.alpha = 0.1
            }, completion: {
                [weak self] _ in
                self?.topView.isHidden = true
                self?.centerView.isHidden = true
                self?.bottomView.isHidden = true
                self?.backgroundView.isHidden = true
        })
    }
    
    // 로딩 상황에 뷰 세팅
    private func startLoading() {
        loadingIndicator.startAnimating()
        playButtonBackgroundView.isHidden = true
    }
    
    // 로딩이 끝난 상황에 뷰 세팅
    private func finishedLoading() {
        loadingIndicator.stopAnimating()
        playButtonBackgroundView.isHidden = false
    }
    
    @objc private func didTapPlayButton() {
        print(#function)
        isPlaying.toggle()
        if isPlaying {
            delegate?.play()
        } else {
            delegate?.pause()
        }
    }
    
    @objc private func didTapSlipButton() {
//        print(#function)
        let timeIntervarForStep: Int64 = 10
        let timeIntervalString = "+" + String(timeIntervarForStep)
        
        let time = stepSlider(timeInterval: timeIntervarForStep)
        
        delegate?.step(time: time)
        
        flowControlButtonAnimation(isRewind: false, timeIntervalString: timeIntervalString)
        
    }
    
    @objc private func didTapRewindButton() {
//        print(#function)
        let timeIntervarForStep: Int64 = -10
        let timeInervalString = String(timeIntervarForStep)
        
        let time = stepSlider(timeInterval: timeIntervarForStep)
        
        delegate?.step(time: time)
        
        flowControlButtonAnimation(isRewind: true, timeIntervalString: timeInervalString)
    }
    
    private func stepSlider(timeInterval: Int64) -> Int64{
        let value = playSlider.value + Float(timeInterval)
//        playSlider.value = value
//        return Int64(playSlider.value)
        return Int64(value)
    }
    
    // slipButton 또는 rewindButton 눌렀을 때의 애니메이션
    private func flowControlButtonAnimation(isRewind: Bool, timeIntervalString: String) {
        let duration = 0.65
        let turm: Double = 0.3
        var currentDuration: Double = 0
        
        let insideView = isRewind ? rewindInsideView: slipInsideView
        let imageView = isRewind ? rewindButtonImageView: slipButtonImageView
        let insideLabel = isRewind ? rewindButtonLabel: slipButtonLabel
        let actionLabel = isRewind ? rewindButtonActionLabel: slipButtonActionLabel
        
        actionLabel.text = timeIntervalString
        
        let range: CGFloat = .dynamicYMargin(margin: 200)
        let rotate = isRewind ? -(CGFloat.pi / 2): CGFloat.pi / 2
        let moveRange = isRewind ? -(range): range
        
        
//        layoutIfNeeded()
//        imageView.backgroundColor = .green
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: currentDuration, relativeDuration: 0.05, animations: {
                actionLabel.transform = .init(translationX: moveRange, y: 0)
                actionLabel.alpha = 1
                imageView.transform = .init(rotationAngle: rotate)
                insideView.alpha = 1
                insideLabel.alpha = 0
                currentDuration += 0.05
            })
            
            UIView.addKeyframe(withRelativeStartTime: currentDuration, relativeDuration: turm, animations: {
                imageView.transform = .identity
                insideView.alpha = 0
                currentDuration += turm
            })
            
            UIView.addKeyframe(withRelativeStartTime: currentDuration, relativeDuration: turm, animations: {
                insideLabel.backgroundColor = .clear
                actionLabel.alpha = 0
                insideLabel.alpha = 1
            })
        }, completion: { _ in
            actionLabel.transform = .identity
        })
        
        isPlaying = true
    }
    
    private func playAction() {
        let imageName = "pause.fill"
        playButtonImageView.image = UIImage(systemName: imageName)
    }
    
    private func pauseAction() {
        let imageName = "play.fill"
        playButtonImageView.image = UIImage(systemName: imageName)
    }
    
    
    
    // x버튼 클릭 이벤트
    @objc private func didTapExitButton() {
        delegate?.exitAction()
    }
    
    
    
    // Int64로 되어있는 시간 값을 시간 형태의 문자열로 반환
    private func replaceIntWithTimeString(second: Int64) -> String {
        let hour = second / 3600
        let minute = (second % 3600) / 60
        let second = (second % 3600) % 60
        
        let hourString = hour < 1 ? "": String(hour) + ":"
        let minuteString = minute < 10 ? "0" + String(minute) + ":": String(minute) + ":"
        let secondString = second < 10 ? "0" + String(second): String(second)
        
        
        return hourString + minuteString + secondString
    }
    
}


extension VideoView {
//    func test() {
//       UIGraphicsBeginImageContext(playButtonBackgroundView.frame.size)
//            let context = UIGraphicsGetCurrentContext()!
//
//            // 삼각형 그리기
//            context.setLineWidth(1.0)
//            context.setStrokeColor(UIColor.green.cgColor)
//            context.setFillColor(UIColor.green.cgColor)
//
//            context.move(to: CGPoint(x: 140, y: 200))
//            context.addLine(to: CGPoint(x: 170, y: 450))
//            context.addLine(to: CGPoint(x: 110, y: 450))
//            context.addLine(to: CGPoint(x: 140, y: 200))
//            context.fillPath() // 선 채우기
//            context.strokePath() // 선으로 그려진 삼각형의 내부 채우기
//
//            // 원 그리기
//            context.setLineWidth(1.0)
//            context.setStrokeColor(UIColor.red.cgColor)
//
//            context.addEllipse(in: CGRect(x: 90, y: 150, width: 100, height: 100))
//            context.addEllipse(in: CGRect(x: 90+50, y: 150, width: 100, height: 100))
//            context.addEllipse(in: CGRect(x: 90-50, y: 150, width: 100, height: 100))
//            context.addEllipse(in: CGRect(x: 90, y: 150-50, width: 100, height: 100))
//            context.addEllipse(in: CGRect(x: 90, y: 150+50, width: 100, height: 100))
//            context.strokePath()
//
//            playButtonBackgroundView = UIGraphicsRendererContext()
//            UIGraphicsEndImageContext()
//        }
//        
//    }
}
