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
        model.againResumDownloadTasks()
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
        
        SavedContentsListModel.shared.profiles.forEach({
            $0.savedContents.forEach({
                $0.isEditing = sender.isSelected
            })
        })
        rootView.setEditingMode()
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
        
        // 마지막 찾아보기 버튼 셀
        guard indexPath.section < model.profiles.count
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PresentFindStorableContentViewControllerButtonCell.identifier, for: indexPath) as! PresentFindStorableContentViewControllerButtonCell
                cell.delegate = self
                return cell
        }
        
        // ContentCell
        let resultCell: SavedContentCell
        let content = model.getContent(indexPath: indexPath)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SavedContentCell.identifier) as? SavedContentCell {
            resultCell = cell
        } else {
            resultCell = SavedContentCell(id: content.contentID, saveContent: content, style: .default, reuseIdentifier: SavedContentCell.identifier)
        }
        resultCell.delegate = self
        resultCell.configure(content: content, isEditingMode: modifyButton.isSelected)
//        print(#function, "*****************************************************")
//        dump(content)
//        print(#function, "*****************************************************")
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
    func shouldBeganSwipeCell(indexPath: IndexPath) {
//        let savedContent = model.getContent(indexPath: indexPath)
        
        print(#function)
        
    }
    
    func beganSwipeCell(content: SaveContent) {
        model.profiles.forEach({
            $0.savedContents.forEach({
                if $0.contentID != content.contentID {
                    $0.isEditing = false
                }
            })
        })
        rootView.setEditingMode()
        print(#function)
        
    }
    
    func endedSwipeCell(content: SaveContent, isEditing: Bool) {
//        let savedContent = model.getContent(indexPath: indexPath)
        content.isEditing = isEditing
    }
    
    func deleteSavedContent(content: SaveContent) {
//        let savedContent = model.getContent(indexPath: indexPath)
        content.deleteContent()
    }
    
    func presentVideonController(content: SaveContent) {
//        let savedContent = model.getContent(indexPath: indexPath)
        guard content.status == .saved else { return }
        presentVideoController(contentID: content.contentID)
    }
    
    func saveContentControl(content: SaveContent) {
//        print(#function, indexPath)
//        let saveContent = SavedContentsListModel.shared.getContent(indexPath: indexPath)
        
        saveContentControl(status: content.status, saveContetnt: content, indexPath: content.indexPath)
    }
    
}



// MARK: Test

extension SavedContentsListViewController {
    func test() {
    }
}

// MARK: SavedContentsListModel

extension SavedContentsListViewController: SavedContentsListModelDelegate {
    
    private func deleteCell(indexPath: IndexPath?) {
        if let indexPath = indexPath {
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
//                print(#function, indexPath, "count:", self.model.profiles.count)
                self.rootView.tableView.deleteRows(at: [indexPath], with: .automatic)
                let profile = self.model.profiles[indexPath.section]
                if profile.savedContents.isEmpty {
                    profile.removeProfile()
                }
            }
        }
    }
    
    func didchange(indexPath: IndexPath?) {
        if let indexPath = indexPath {
//            print("DeleteCell==========================================")
            deleteCell(indexPath: indexPath)
        } else {
//            print("modify VC ================================================")
            DispatchQueue.main.async {
                [weak self] in
                self?.modifyViewController()
            }
        }
    }
    
    func deleteProfile(section: Int) {
           print(section)
       }
    
}


