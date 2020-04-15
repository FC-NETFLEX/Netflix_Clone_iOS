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
    private var model = SavedContentsListModel.shared

    //MARK: LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setUI()
        test()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let status = model.profiles.isEmpty
        navigationController?.navigationBar.isHidden = status
        rootView.isNoContents = status
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.profiles[section].savedConetnts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedContentCell.identifier, for: indexPath) as! SavedContentCell
        
        let content = model.getContent(indexPath: indexPath)
        let description = content.rating + " | " + String(content.capacity) + " MB"
        cell.configure(
            title: content.title,
            description: description,
            stringImageURL: content.imageURL,
            summary: content.isSelected ? content.summary: ""
            )
        
        return cell
    }
    
    
    
}

//MARK: UITableViewDelegate

extension SavedContentsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for (section, profile) in model.profiles.enumerated() {
            for (row, content) in profile.savedConetnts.enumerated() {
                if IndexPath(row: row, section: section) != indexPath && content.isSelected {
                    content.isSelected = false
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        model.profiles[indexPath.section].savedConetnts[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}


// MARK: Test

extension SavedContentsListViewController {
    func test() {
        let url = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)
        print(url)
    }
}




