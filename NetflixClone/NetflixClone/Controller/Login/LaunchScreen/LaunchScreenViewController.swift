//
//  LaunchScreenViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//


import UIKit

class LaunchScreenViewController: UIViewController {
    let scrollView = UIScrollView()
    let pageController = UIPageControl()
    let loginButtonAtStartVC = UIButton()
    
    let view1 = FirstView()
    let view2 = SecondView()
    let view3 = ThirdView()
    let view4 = ForthView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        scrollView.delegate = self

        setNavigationBar()
        setUI()
    }
            
    private func setUI() {
        [scrollView, loginButtonAtStartVC, pageController].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loginButtonAtStartVC.titleLabel?.font = UIFont.dynamicFont(fontSize: 15, weight: .light)
        loginButtonAtStartVC.setTitle("로그인", for: .normal)
        loginButtonAtStartVC.setTitleColor(.white, for: .normal)
        loginButtonAtStartVC.setBackgroundColor(#colorLiteral(red: 0.8901960784, green: 0.03921568627, blue: 0.07450980392, alpha: 1), for: .normal)
        loginButtonAtStartVC.addTarget(self, action: #selector(touchLoginButton(_:)), for: .touchUpInside)
        
        // scrollView에서 페이징이 가능하도록 설정
        scrollView.isPagingEnabled = true
        pageController.numberOfPages = 4
        pageController.currentPageIndicatorTintColor = #colorLiteral(red: 0.8901960784, green: 0.03921568627, blue: 0.07450980392, alpha: 1)
        pageController.pageIndicatorTintColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        
        setConstraints()
    }
    
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        let xMargin = CGFloat.dynamicXMargin(margin: 10)
        let yValue = CGFloat.dynamicYMargin(margin: 50)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            loginButtonAtStartVC.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            loginButtonAtStartVC.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: xMargin),
            loginButtonAtStartVC.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -xMargin),
            loginButtonAtStartVC.heightAnchor.constraint(equalToConstant: yValue),
            
            pageController.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageController.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -yValue),
        ])
        
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
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let logoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        logoButton.setBackgroundImage(UIImage(named: "Logo"), for: .normal)
        logoButton.addTarget(self, action: #selector(touchNetflixButton(_:)), for: .touchUpInside)
        logoButton.imageView?.contentMode = .scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButton)
        
        let signUpButton = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(touchSignUpButton(_:)))
        signUpButton.tintColor = .white
        let personalInfoButton = UIBarButtonItem(title: "개인정보", style: .plain, target: self, action: #selector(touchPersonalInfoButton(_:)))
        
        personalInfoButton.tintColor = .white
        navigationItem.rightBarButtonItems = [signUpButton, personalInfoButton]
    }
    
    @objc private func touchNetflixButton(_ sender: UIButton) {
        print("넷플릭스 이미지 들어가는 버튼")
    }
    
    @objc private func touchSignUpButton(_ sender: UIButton) {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func touchPersonalInfoButton(_ sender: UIButton) {
        print("개인정보")
    }
    
    @objc private func touchLoginButton(_ sender: UIButton) {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

extension LaunchScreenViewController: UIScrollViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pageController.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}

