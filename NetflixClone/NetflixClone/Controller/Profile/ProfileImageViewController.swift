//
//  ProfileImageViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ProfileImageViewController: UIViewController {
    
    private let topView = TopCustomView()
    private var category = ["temp1","temp2","temp3","temp4","temp5","temp6","temp7","temp8"]
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let profileData = [UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
//        setNavigationBar()
        requestProfileImage()
        
    }
//    private func setNavigationBar() {
//        
//        navigationItem.title = "아이콘 선택"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//  
//    }
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
    
    private func requestProfileImage() {
        guard let token = LoginStatus.shared.getToken() else { return }
        
        APIManager().requestOfGet(url: .iconList, token: token, completion: {
            result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            case .failure(let error):
                print(error)
            }
        })
    }

}
extension ProfileImageViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 10 }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .setNetfilxColor(name:.netflixGray)
        label.text = category[section]
        label.textColor = .white
        return label
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        category[section]
//
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableVIewCell.identifier, for: indexPath) as? ProfileTableVIewCell else { fatalError() }
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cell
    }
    
    
}

extension ProfileImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundView = UIImageView(image: profileData[indexPath.item])
        return cell
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
