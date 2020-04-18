//
//  SaveContentListViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SavedContentsListViewController: BaseViewController {
    
    private let rootView = SavedContentsListView()
    private var model: SavedContentsListModel = SavedContentsListModel.shared 

    //MARK: LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setUI()
        model.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let status = model.profiles.isEmpty
        navigationController?.navigationBar.isHidden = status
        rootView.isNoContents = status
        rootView.tableView.reloadData()
        dump(model.profiles)
        
    }
    
    //MARK: UI
    
    private func setUI() {
        rootView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
    }
    
    private func setNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let modifyButton = UIButton()
        modifyButton.setImage(UIImage(named: "펜슬"), for: .normal)
        modifyButton.setImage(UIImage(), for: .selected)
        
        modifyButton.setTitle("완료", for: .selected)
        
        modifyButton.tintColor = .setNetfilxColor(name: .white)
        modifyButton.addTarget(self, action: #selector(didTapModifyButtotn(_:)), for: .touchUpInside)
        let rightBarButtton = UIBarButtonItem(customView: modifyButton)
        navigationItem.rightBarButtonItem = rightBarButtton
    }
    
    @objc private func didTapModifyButtotn(_ sender: UIButton) {
        print(#function)
        sender.isSelected.toggle()
        
    }

}


//MARK: SavedContentsListViewDelegate

extension SavedContentsListViewController: SavedContentsListViewDelegate {
    
    func findStorableContent() {
        print(#function)
        tabBarController?.selectedIndex = 0
    }
    
}

//MARK: UITableViewDataSource

extension SavedContentsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.profiles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var resultHeaderView: SavedContentHeaderView
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SavedContentHeaderView.identifire) as? SavedContentHeaderView {
            resultHeaderView = headerView
        } else {
            let headerView = SavedContentHeaderView(reuseIdentifier: SavedContentHeaderView.identifire)
            resultHeaderView = headerView
        }
        
        let profile = model.profiles[section]
        resultHeaderView.configure(imageURL: profile.imageURL, title: profile.name)
        
        return resultHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.profiles[section].savedContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resultCell: SavedContentCell
        let content = model.getContent(indexPath: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: SavedContentCell.identifier) as? SavedContentCell {
            resultCell = cell
        } else {
            resultCell = SavedContentCell(id: content.contentID, style: .default, reuseIdentifier: SavedContentCell.identifier)
        }
        
        
        resultCell.configure(content: content)
        
        return resultCell
    }
    
    
    
}

//MARK: UITableViewDelegate

extension SavedContentsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (section, profile) in model.profiles.enumerated() {
            for (row, content) in profile.savedContents.enumerated() {
                if IndexPath(row: row, section: section) != indexPath && content.isSelected {
                    content.isSelected = false
                    let indexPath = IndexPath(row: row, section: section)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }

        model.profiles[indexPath.section].savedContents[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}


// MARK: Test

extension SavedContentsListViewController {
    func test() {
    }
}

// MARK: SavedContentsListModel

extension SavedContentsListViewController: SavedContentsListModelDelegate {
    func didchange() {
        DispatchQueue.main.async {
            [weak self] in
            self?.rootView.tableView.reloadData()
        }
    }
    
}


