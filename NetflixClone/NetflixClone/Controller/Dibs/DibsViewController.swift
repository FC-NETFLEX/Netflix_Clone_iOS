//
//  DibsViewController.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class DibsViewController: UIViewController {
    
    private let dibsView = DibsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        navigationController?.navigationBar.barTintColor = UIColor.setNetfilxColor(name: .black)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.setNetfilxColor(name: .white)]

        view.backgroundColor = UIColor.setNetfilxColor(name: .black)
        
        
        title = "내가 찜한 콘텐츠"
        view.addSubview(dibsView)
        
        
        let guide = self.view.safeAreaLayoutGuide
        
        dibsView.snp.makeConstraints {
            $0.top.equalTo(guide.snp.top)
            $0.bottom.equalTo(guide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

    }
    
   
}
