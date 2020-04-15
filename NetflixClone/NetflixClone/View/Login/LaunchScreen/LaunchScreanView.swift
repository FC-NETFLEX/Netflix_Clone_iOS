//
//  LaunchScreanView.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/03.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

protocol LaunchScreanViewDelegate: class {
    func pushLogInViewController()
}

class LaunchScreanView: UIView {
    
    weak var delegate: LaunchScreanViewDelegate?
    
    private let scrollView = UIScrollView()
    private let pageController = UIPageControl()
    private let loginButtonAtStartVC = UIButton()
    
    private let view1 = FirstView()
    private let view2 = SecondView()
    private let view3 = ThirdView()
    private let view4 = ForthView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [scrollView, loginButtonAtStartVC, pageController].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loginButtonAtStartVC.titleLabel?.font = UIFont.dynamicFont(fontSize: 15, weight: .light)
        loginButtonAtStartVC.setTitle("로그인", for: .normal)
        loginButtonAtStartVC.setTitleColor(.white, for: .normal)
        loginButtonAtStartVC.setBackgroundColor(#colorLiteral(red: 0.8901960784, green: 0.03921568627, blue: 0.07450980392, alpha: 1), for: .normal)
        loginButtonAtStartVC.addTarget(self, action: #selector(touchLoginButton(_:)), for: .touchUpInside)
        
        // scrollView에서 페이징이 가능하도록 설정
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        pageController.numberOfPages = 4
        pageController.currentPageIndicatorTintColor = #colorLiteral(red: 0.8901960784, green: 0.03921568627, blue: 0.07450980392, alpha: 1)
        pageController.pageIndicatorTintColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        
    }
    
    private func setConstraints() {
        let guide = safeAreaLayoutGuide
        
        let xMargin = CGFloat.dynamicXMargin(margin: 10)
        let loginButtonHeight = CGFloat.dynamicYMargin(margin: 50)
        
        scrollView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(guide)
        })
        
        loginButtonAtStartVC.snp.makeConstraints({
            $0.bottom.equalTo(guide)
            $0.leading.trailing.equalTo(guide).inset(xMargin)
            $0.height.equalTo(loginButtonHeight)
        })
        
        pageController.snp.makeConstraints({
            $0.centerX.equalTo(guide)
            $0.bottom.equalTo(loginButtonAtStartVC.snp.top)
        })
        
        
        let views = [view1, view2, view3, view4]
        for (index, view) in views.enumerated() {
            
            scrollView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let leading = index == 0 ? scrollView.leadingAnchor: views[index - 1 ].trailingAnchor
            
            view.leadingAnchor.constraint(equalTo: leading).isActive = true
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            if index == views.count - 1 {
                view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
        }
    }
    
    @objc private func touchLoginButton(_ sender: UIButton) {
        delegate?.pushLogInViewController()
    }
    
}


extension LaunchScreanView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}
