//
//  PlayButton.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/30.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit


class PlayPauseButton: UIView {

    // public function can be called from out interface
    func setPlaying(_ playing: Bool) {
        self.playing = playing
        animateLayer()
    }

    private (set) var playing: Bool = false
    private let leftLayer: CAShapeLayer
    private let rightLayer: CAShapeLayer

    override init(frame: CGRect) {
        leftLayer = CAShapeLayer()
        rightLayer = CAShapeLayer()
        super.init(frame: frame)

        backgroundColor = .clear
        setupLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    private func setupLayers() {
        layer.addSublayer(leftLayer)
        layer.addSublayer(rightLayer)

        leftLayer.fillColor = UIColor.setNetfilxColor(name: .white).cgColor
        rightLayer.fillColor = UIColor.setNetfilxColor(name: .white).cgColor
    }

    @objc private func pressed() {
        
        setPlaying(!playing)
        
    }

    private func animateLayer() {
        let fromLeftPath = leftLayer.path
        let toLeftPath = leftPath()
        leftLayer.path = toLeftPath

        let fromRightPath = rightLayer.path
        let toRightPath = rightPath()
        rightLayer.path = toRightPath

        let leftPathAnimation = pathAnimation(fromPath: fromLeftPath,
                                              toPath: toLeftPath)
        let rightPathAnimation = pathAnimation(fromPath: fromRightPath,
                                               toPath: toRightPath)

        leftLayer.add(leftPathAnimation,
                      forKey: nil)
        rightLayer.add(rightPathAnimation,
                       forKey: nil)
    }

    private func pathAnimation(fromPath: CGPath?,
                               toPath: CGPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.33
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.fromValue = fromPath
        animation.toValue = toPath
        return animation
    }

    override func layoutSubviews() {
        leftLayer.frame = leftLayerFrame
        rightLayer.frame = rightLayerFrame

        leftLayer.path = leftPath()
        rightLayer.path = rightPath()
    }

    private let pauseButtonLineSpacing: CGFloat = 10

    private var leftLayerFrame: CGRect {
        return CGRect(x: 0,
                      y: 0,
                      width: bounds.width * 0.5,
                      height: bounds.height)
    }

    private var rightLayerFrame: CGRect {
        return leftLayerFrame.offsetBy(dx: bounds.width * 0.5,
                                       dy: 0)
    }

    private func leftPath() -> CGPath {
        if playing {
            let bound = leftLayer.bounds
                                 .insetBy(dx: pauseButtonLineSpacing,
                                          dy: 0)
                                 .offsetBy(dx: -pauseButtonLineSpacing,
                                           dy: 0)

            return UIBezierPath(rect: bound).cgPath
        }

        return leftLayerPausedPath()
    }

    private func rightPath() -> CGPath {
        if playing {
            let bound = rightLayer.bounds
                                 .insetBy(dx: pauseButtonLineSpacing,
                                          dy: 0)
                                .offsetBy(dx: pauseButtonLineSpacing,
                                          dy: 0)
            return UIBezierPath(rect: bound).cgPath
        }

        return rightLayerPausedPath()
    }

    private func leftLayerPausedPath() -> CGPath {
        let y1 = leftLayerFrame.width * 0.5
        let y2 = leftLayerFrame.height - leftLayerFrame.width * 0.5

        let path = UIBezierPath()
        path.move(to:CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: leftLayerFrame.width,
                                 y: y1))
        
        path.addLine(to: CGPoint(x: leftLayerFrame.width,
                                 y: y2))
        
        path.addLine(to: CGPoint(x: 0,
                                 y: leftLayerFrame.height))
        path.close()

        return path.cgPath
    }

    private func rightLayerPausedPath() -> CGPath {
        let y1 = rightLayerFrame.width * 0.5
        let y2 = rightLayerFrame.height - leftLayerFrame.width * 0.5
        let path = UIBezierPath()

        path.move(to:CGPoint(x: 0, y: y1))
        path.addLine(to: CGPoint(x: rightLayerFrame.width,
                                 y: rightLayerFrame.height * 0.5))
        path.addLine(to: CGPoint(x: rightLayerFrame.width,
                                 y: rightLayerFrame.height * 0.5))
        path.addLine(to: CGPoint(x: 0,
                                 y: y2))
        path.close()
//        print(rightLayerFrame)
        return path.cgPath
    }
}
