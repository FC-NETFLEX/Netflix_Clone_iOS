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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setNevigationController()
        setUI()
        setConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //MARK: UI
    
    private func setUI() {
        view.addSubview(rootView)
        view.backgroundColor = .setNetfilxColor(name: .black)
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }
    
    private func setNevigationController() {
        
        navigationController?.navigationBar.tintColor = .setNetfilxColor(name: .white)
        let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .done, target: self, action: #selector(popViewController))
        
        navigationItem.leftBarButtonItem = backButton
        
        
        let titleLabel = UILabel()
        titleLabel.text = "저장 가능"
        titleLabel.textColor = .setNetfilxColor(name: .white)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.isHidden = false
        
    }
    
    private func setConstraints() {
        
        rootView.snp.makeConstraints({
            $0.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: FindStorableContentModelDelegate
extension FindStorableContentViewController: FindStorableContentModelDelegate {
    
    func categorysDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.tableView.reloadData()
        }
    }
    
}


//MARK: UITableViewDataSource
extension FindStorableContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindStorableContentTableViewCell.identifier, for: indexPath) as! FindStorableContentTableViewCell
        let category = model.categorys[indexPath.row]
        let categoryName = model.categorymNames[category.categoryID]
        cell.configure(categoryName: categoryName, contents: category.contents)
        cell.delegate = self
        return cell
    }
    
    
}

//MARK: UITableViewDelegate
extension FindStorableContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height * 0.33
    }
}

extension FindStorableContentViewController: FindStorableContentTableViewCellDelegate {
    
    func selectedContent(contentID: Int) {
        
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: contentID))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        present(contentVC, animated: true)
        
    }
}

