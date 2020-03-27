//
//  ProfileImageViewController.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/03/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class ProfileImageViewController: UIViewController {
    
   private var category = ["temp1","temp2","temp3","temp4","temp5","temp6","temp7","temp8"]
   private let tableView = UITableView()
    
   private let profileData = [UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3"),UIImage(named: "프로필1"),UIImage(named: "프로필2"),UIImage(named: "프로필3")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        
        
    }
   private func setUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ProfileTableVIewCell.self, forCellReuseIdentifier: ProfileTableVIewCell.identifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
   private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
    }
    
}
extension ProfileImageViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        category[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        cell.backgroundView = UIImageView(image: profileData[indexPath.item])
        
        return cell
    }
}

extension ProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.height - 20 - 10)
        return CGSize(width: size, height: size)
    }
}
