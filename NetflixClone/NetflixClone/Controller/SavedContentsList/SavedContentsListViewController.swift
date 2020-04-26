//
//  SaveContentListViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SavedContentsListViewController: CanSaveViewController {
    
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
        modifyViewController()
        
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
        rootView.tableView.setEditing(sender.isSelected, animated: true)
    }
    
    private func modifyViewController() {
        let status = model.profiles.isEmpty
        navigationController?.navigationBar.isHidden = status
        rootView.isNoContents = status
        rootView.tableView.reloadData()
    }

}


//MARK: SavedContentsListViewDelegate

extension SavedContentsListViewController: SavedContentsListViewDelegate {
    
    func findStorableContent() {
        navigationController?.pushViewController(FindStorableContentViewController(), animated: true)
    }
    
}

//MARK: UITableViewDataSource

extension SavedContentsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.profiles.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < model.profiles.count else { return nil}
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
        if section < model.profiles.count {
            return model.profiles[section].savedContents.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section < model.profiles.count
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PresentFindStorableContentViewControllerButtonCell.identifier, for: indexPath) as! PresentFindStorableContentViewControllerButtonCell
                cell.delegate = self
                return cell
        }
        
        let resultCell: SavedContentCell
        let content = model.getContent(indexPath: indexPath)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SavedContentCell.identifier) as? SavedContentCell {
            resultCell = cell
        } else {
            resultCell = SavedContentCell(id: content.contentID, style: .default, reuseIdentifier: SavedContentCell.identifier)
        }
        resultCell.delegate = self
        resultCell.configure(content: content)
        
        return resultCell
    }
    
    
    
}

//MARK: UITableViewDelegate

extension SavedContentsListViewController: UITableViewDelegate {
    
    // 컨텐츠 선택시 줄거리 보여주는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < model.profiles.count else { return }
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < model.profiles.count {
            return tableView.bounds.height / 18
        } else {
            return 0
        }
    }
}


// MARK: SavedContentCellDelegate
extension SavedContentsListViewController: SavedContentCellDelegate {
    func presentVideonController(contentID: Int) {
        presentVideoController(contentID: contentID)
    }
    
    func saveContentControl(status: SaveContentStatus, id: Int) {
        guard let saveContent = SavedContentsListModel.shared.getContent(contentID: id) else { return }
        saveContentControl(status: status, saveContetnt: saveContent)
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
            self?.modifyViewController()
        }
    }
    
}


