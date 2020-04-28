//
//  SaveContentListViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SavedContentsListViewController: CanSaveViewController {
    private let modifyButton = UIButton()
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
        
        modifyButton.snp.makeConstraints {
            $0.width.equalTo(modifyButton.snp.height)
        }
        
        modifyButton.setImage(UIImage(named: "저장펜슬"), for: .normal)
        modifyButton.setImage(UIImage(), for: .selected)
        
        modifyButton.setTitle("완료  ", for: .selected)
        
        modifyButton.tintColor = .setNetfilxColor(name: .white)
        modifyButton.addTarget(self, action: #selector(didTapModifyButtotn(_:)), for: .touchUpInside)
        let rightBarButtton = UIBarButtonItem(customView: modifyButton)
        navigationItem.rightBarButtonItem = rightBarButtton
    }
    
    @objc private func didTapModifyButtotn(_ sender: UIButton) {
        sender.isSelected.toggle()
        rootView.setEditingMode(isEditing: sender.isSelected)
//        rootView.tableView.allowsSelectionDuringEditing = sender.isSelected
//        print(rootView.tableView.isEditing)
//        rootView.tableView.setEditing(sender.isSelected, animated: true)
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
        resultCell.configure(content: content, isEditing: modifyButton.isSelected)
        
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard indexPath.section < model.profiles.count else { return UITableView.automaticDimension }
//        return tableView.bounds.height / 9
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < model.profiles.count {
            return tableView.bounds.height / 14
        } else {
            return 0
        }
    }
    
//    // swipe로 컨텐츠 삭제
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        guard !modifyButton.isSelected else { return nil}
//
//        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {
//
//            [weak self] (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
//            guard let self = self else { return }
//
//            let savedContent = self.model.getContent(indexPath: indexPath)
//            savedContent.deleteContent()
//            completion(false)
//        })
//        deleteAction.image = UIImage(systemName: "xmark")
//
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        configuration.performsFirstActionWithFullSwipe = false
//
//        return configuration
//    }
    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        print(#function)
//
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        print(#function)
//        return true
//    }
    
    
//    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
//        print(#function)
//        return false
//    }
}



// MARK: SavedContentCellDelegate
extension SavedContentsListViewController: SavedContentCellDelegate {
    func deleteSavedContent(contentID: Int) {
        guard let savedContent = SavedContentsListModel.shared.getContent(contentID: contentID) else { return }
        savedContent.deleteContent()
    }
    
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


