//
//  FindCanSaveViewController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class FindStorableContentViewController: BaseViewController {
    
    private let rootView = FindStorableContentView()
    private lazy var model = FindStorableContentModel(delegate: self)
    
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNevigationController()
        setUI()
    }
    
    //MARK: UI
    
    private func setUI() {
        rootView.tableView.dataSource = self
    }
    
    private func setNevigationController() {
        
        navigationController?.navigationBar.tintColor = .setNetfilxColor(name: .white)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popViewController))
        
        navigationItem.leftBarButtonItem = backButton
        
        
        let titleLabel = UILabel()
        titleLabel.text = "저장 가능"
        titleLabel.textColor = .setNetfilxColor(name: .white)
        navigationItem.titleView = titleLabel
    }
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension FindStorableContentViewController: FindStorableContentModelDelegate {
    
    func categorysDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.tableView.reloadData()
        }
    }
    
}


extension FindStorableContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print("Content Count:", model.categorys[indexPath.row].contents.count)
        let title = model.categorymNames[model.categorys[indexPath.row].categoryID]
        cell.textLabel?.text = title
        return cell
    }
    
    
}


