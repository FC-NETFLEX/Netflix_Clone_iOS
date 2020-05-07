//
//  ProfileImageViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol ProfileImageViewControllerDelegate: class {
    func setImage(image: UIImage, imageID: Int)
}

class ProfileImageViewController: UIViewController {
    
    var delegate: ProfileImageViewControllerDelegate?
    
    private let topView = TopCustomView()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        requestProfileImage()
        
    }
     //MARK: SETUI
    private func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)
        topView.delegate = self
        view.addSubview(topView)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .setNetfilxColor(name: .netflixGray)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ProfileTableVIewCell.self, forCellReuseIdentifier: ProfileTableVIewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        [topView,tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        topView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: guide.topAnchor, constant: 64).isActive = true
        
        tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 64).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
     //MARK: API - 요청
    private func requestProfileImage() {
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.iconList.makeURL()
            else { return }

        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard
                let data = data,
                let categorys = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                else { return }
            
            for category in categorys {
                guard
                    let name = category["category_name"] as? String,
                    let profileIcons = category["profileIcons"] as? [[String: Any]]
                    else { return }
                
                var icon = [Icon]()
                
                for i in profileIcons {
                    guard
                        let id = i["id"] as? Int,
                        let iconURL = i["icon"] as? String
                        else { return }
                    
                    let temp = Icon(id: id, iconURL: iconURL)
                    icon.append(temp)
                }
                
                self?.categoryList.append(CategoryList(name: name, icon: icon))
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        task.resume()

    }
    private var categoryList = [CategoryList]()
}

extension ProfileImageViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 10 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .setNetfilxColor(name:.netflixGray)
        label.text = categoryList[section].name
        label.textColor = .white
        return label
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = ProfileTableVIewCell()
        cell.collectionView.tag = indexPath.section
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tempCell = cell as? ProfileTableVIewCell else { return }
        tempCell.collectionView.contentOffset = .zero
    }
}

extension ProfileImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var randomArray = [String]()
        let id = categoryList[collectionView.tag].icon[indexPath.row].id
        let url = categoryList[collectionView.tag].icon[indexPath.row].iconURL
        randomArray.append(url)
        guard let profileImage = ImageCaching.shared.data[url] else { return }
        
        delegate?.setImage(image: profileImage, imageID: id)
        dismiss(animated: true)
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryList[collectionView.tag].icon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundView = nil
        let key = categoryList[collectionView.tag].icon[indexPath.row].iconURL
  
        if let image = ImageCaching.shared.data[key] {
            cell.backgroundView = UIImageView(image: image)
            
        } else {
            guard let url = URL(string: key) else { fatalError() }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard
                    let data = data,
                    let image = UIImage(data: data),
                    let self = self
                    else { return }
                
                DispatchQueue.main.async {
                    ImageCaching.shared.data[key] = image
                    cell.backgroundView = UIImageView(image: image)
                }
            }
            task.resume()
        }
        return cell
    }
}

class ImageCaching {
    static let shared = ImageCaching()
    private init() {}
    
    var data = [String: UIImage]() {
        didSet {
        }
    }
}

extension ProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        return CGSize(width: size, height: size)
    }
}
extension ProfileImageViewController: TopCustomViewDelegate {
    func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
