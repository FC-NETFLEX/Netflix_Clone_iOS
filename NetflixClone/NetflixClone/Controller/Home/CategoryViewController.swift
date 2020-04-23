//
//  CategoryViewController.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let categoryNum: Int
    let rootView = CategoryView()
    
    //MARK: initializer
    init(categoryNum: Int) {
        self.categoryNum = categoryNum
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MAKR: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: UI
    private func setUI() {
//        rootView.tableView.dataSource = self
//        rootView.tableView.delegate = self
        
        view.addSubview(rootView)
        rootView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

//MARK: UITable DataSource
//extension CategoryViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
//
////MARK: UITable Delegate
//extension CategoryViewController: UITableViewDelegate {
//
//}


