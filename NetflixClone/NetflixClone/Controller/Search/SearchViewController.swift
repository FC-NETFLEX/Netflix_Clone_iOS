//
//  SearchViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
// Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

// indicator

class SearchViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Properties
    // MARK:  - Search Result CollectionView Datas
    private var searchResultDatas = [SearchContent]() {
        didSet {
            searchView.searchResultCollectionView.reloadData()
            if !isSearchBarEmpty && searchResultDatas.count == 0 {
                searchView.noSearchResultsLabel.isHidden = false
                searchView.searchResultCollectionView.isHidden = true
            } else {
                searchView.noSearchResultsLabel.isHidden = true
                searchView.searchResultCollectionView.isHidden = false
            }
        }
    }
    
    private var isSearchBarEmpty: Bool {
        return contentsSearchBar.text?.isEmpty ?? true
    }
    
    private var dataTask: URLSessionDataTask?
    
    private let flowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)
    
    private let searchView = SearchView()
    private lazy var contentsSearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        setSearchBarInNavigation()
        setSearchController()
        setSearchView()
    }

    // MARK: 화면 내리면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        searchBarTextDidEndEditing(contentsSearchBar)
    }
    
    // MARK: SearchView 세팅
    private func setSearchView() {
        searchView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(5)
            make.trailing.equalTo(view.snp.trailing).offset(-5)
        }
        
    }
    
    // MARK: SearchController - NavigationBar 세팅
    private func setSearchBarInNavigation() {
        // NavigationBar 투명하게 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationItem.titleView = contentsSearchBar
        
        // searchTextField 내부 세팅
        contentsSearchBar.tintColor = UIColor.setNetfilxColor(name: .white)
        contentsSearchBar.placeholder = "검색"
        contentsSearchBar.setValue("취소", forKey: "cancelButtonText")
        contentsSearchBar.searchTextField.backgroundColor = UIColor.setNetfilxColor(name: .netflixDarkGray)
        contentsSearchBar.searchTextField.textColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        contentsSearchBar.searchTextField.clearButtonMode = .whileEditing
        contentsSearchBar.searchTextField.leftView?.tintColor = UIColor.setNetfilxColor(name: .netflixLightGray)
        
    }
    
    // MARK: SearchView 세팅
    private func setSearchController() {
        contentsSearchBar.delegate = self
        contentsSearchBar.returnKeyType = .default
        
        searchView.searchResultCollectionView.dataSource = self
        searchView.searchResultCollectionView.delegate = self
        //        definesPresentationContext = true // iOS 13 미만에서만 해줌, 13은 필요없음. 서치바에 커서 올라가면 주변 어두워지는 기능
    }
    
    // MARK:  - Search request
    private func request(id: Int, keyword: String) {
        let urlString = "https://netflexx.ga/profiles/\(id)/contents/search/?keyword=\(keyword)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
            let token = LoginStatus.shared.getToken() else { return }
        self.dataTask =  APIManager().request(url: url, method: .get, token: token) { (result) in
            
            switch result {
            case .success(let data):
                if let results = try? JSONDecoder().decode([SearchContent].self, from: data) {
                    DispatchQueue.main.async {
                        self.searchResultDatas = results
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.dataTask?.resume()
    }
    
}

// MARK: Search Result Collection View DataSource, Delegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultDatas.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultCollectionViewHeader.identifier, for: indexPath) as! SearchResultCollectionViewHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBasicItem.identifier, for: indexPath) as! ContentsBasicItem
        
        cell.jinConfigure(urlString: searchResultDatas[indexPath.row].image)
        return cell
    }
    
    // MARK: present ContentVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentVC = UINavigationController(rootViewController: ContentViewController(id: searchResultDatas[indexPath.row].id))
        contentVC.modalPresentationStyle = .overCurrentContext
        contentVC.modalTransitionStyle = .crossDissolve
        self.present(contentVC, animated: true)
    }
}

// MARK: Search Result Collection View FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return flowLayout.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.linesOnScreen
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return searchView.setFlowLayout()
    }
}

// MARK: searchBar Delegate
extension SearchViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        contentsSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contentsSearchBar.text = ""
        searchResultDatas.removeAll()
        searchBar.endEditing(true)
        searchBarTextDidEndEditing(contentsSearchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        contentsSearchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let profileID = LoginStatus.shared.getProfileID() else { return }
        
        if searchText != "" {
            self.dataTask?.cancel()
            request(id: profileID, keyword: searchText)
        } else {
            contentsSearchBar.resignFirstResponder()
            searchResultDatas.removeAll()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: 네비게이션바 때문에 가려져서 preferredStatusBarStyle 안먹히기 때문에 사용
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
