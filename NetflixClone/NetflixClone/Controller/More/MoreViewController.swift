//
//  MoreViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MoreViewController: UIViewController {
    
    private var userArray = [MorePofileView]()
    private let stackView = UIStackView()
    private let netflixView = NetflixView()
    private let profileButton = ProfileManageButton()
    private let moreTableView = UITableView()
    private let logoutButton = LogoutVersionButton()
    
    private var userProfileList = [ProfileList]()
    private var userIconList = [ProfileIcons]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUI()
        setConstraints()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reqeustProfileList()
        
    }
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    private func profileStactViewSetting() {
        
        let userView0 = UIView()
        let userView1 = UIView()
        let userView2 = UIView()
        let userView3 = UIView()
        let userView4 = UIView()
        var userViewArray = [UIView]()
        
        [userView0,userView1,userView2,userView3,userView4].forEach {
            userViewArray.append($0)
        }
        
        let count = userProfileList.count
        print(count)
        for (index, userView) in userViewArray.enumerated() {
            userView.subviews.forEach { $0.removeFromSuperview() }
            
            if index < count {
                let tempProfileView = MorePofileView()
                tempProfileView.delegate = self
                tempProfileView.tag = index
                tempProfileView.profileLabel.text = userProfileList[index].name
                let button = tempProfileView.profileButton
                setImage(stringURL: userIconList[index].iconURL, button: button)
                stackView.addArrangedSubview(tempProfileView)
                userArray.append(tempProfileView)
                
                tempProfileView.snp.makeConstraints {
                    $0.width.equalToSuperview().multipliedBy(0.17)
                    
                    $0.top.equalToSuperview()
                }
                
            } else if index == count {
                let tempAddView = MoreAddProfileButtonView()
                stackView.addArrangedSubview(tempAddView)
                tempAddView.delegate = self
                tempAddView.snp.makeConstraints {
                    $0.width.equalToSuperview().multipliedBy(0.18)
                    $0.top.equalToSuperview()
                }
            }
        }
    }
    private func setImage(stringURL: String, button: UIButton) {
        guard let url = URL(string: stringURL) else { return }
        KingfisherManager.shared.retrieveImage(with: url, completionHandler: {
            result in
            switch result {
            case .success(let imageResult):
                button.setImage(imageResult.image, for: .normal)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)
        [stackView,profileButton,netflixView,moreTableView,logoutButton].forEach {
            view.addSubview($0)
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        profileButton.delegate = self
        
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.separatorColor = .setNetfilxColor(name: .black)
        moreTableView.backgroundColor = .setNetfilxColor(name: .black)
        moreTableView.register(MoreViewTableCell.self, forCellReuseIdentifier: MoreViewTableCell.identifier)
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let padding: CGFloat = 30
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding * 2)
            $0.leading.equalToSuperview().inset(padding)
            $0.trailing.equalToSuperview().offset(-padding)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        profileButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalTo(guide)
            $0.height.equalToSuperview().multipliedBy(0.08)
        }
        netflixView.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.22)
        }
        moreTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(netflixView.snp.bottom)
            $0.bottom.equalTo(logoutButton.snp.top)
            
        }
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(guide)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
    }
    //    MARK: API
    func reqeustProfileList() {
        guard
            let token = LoginStatus.shared.getToken(),
            let url = APIURL.makeProfile.makeURL()
            else { return }
        print(token)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("TOKEN \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, _, _) in
            guard
                let data = data,
                let profileLists = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                else { return }
           
            self.userIconList.removeAll()
            self.userProfileList.removeAll()
            
            for profileList in profileLists {
                guard
                    let id = profileList["id"] as? Int,
                    let name = profileList["profile_name"] as? String,
                    let iskids = profileList["is_kids"] as? Bool,
                    let profileIcons = profileList["profile_icon"] as? [String: Any]
                    else { return }
                
                self.userProfileList.append(ProfileList(id: id, name: name, iskids: iskids))
                
                
                guard
                    let idNum = profileIcons["id"] as? Int,
                    let iconURL = profileIcons["icon"] as? String
                    else { return }
             
                self.userIconList.append(ProfileIcons(idNum: idNum, iconURL: iconURL))
                
                
                
            }
            DispatchQueue.main.async {
                self.profileStactViewSetting()
            }
        }
        
        task.resume()
    }
    
    private func alertAction() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠어요?", preferredStyle: .alert)
        let no = UIAlertAction(title: "아니요", style: .default) { _ in
        }
        let ok = UIAlertAction(title: "예", style: .default) { _ in
            LoginStatus.shared.logout()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let window = appDelegate.window
            let rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
            
        }
        alert.addAction(no)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    @objc private func didTapLogoutButton() {
        alertAction()
    }
    private func imageSetting() {
        
        let addVC = AddProfileViewController(root: .add)
        
        //        switch userIconList[id].isEmpty {
        //        case true:
        //            addVC.randomSetImage = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/profile/icon/icon3.png"
        //            addVC.randomIndex = 3
        //
        //        case false:
        //            guard let imageIndex = (0..<self.userIconList[].count).randomElement() else { return }
        //            addVC.randomSetImage = self.userImageArray[imageIndex]
        //            addVC.randomIndex = self.userIDNumArray[imageIndex]
        //        }
        
        let navi = UINavigationController(rootViewController: addVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
}
extension MoreViewController: MoreProfileViewDelegate {
    
    func profileButtonDidTap(tag: Int) {
        LoginStatus.shared.selectedProfile(profileID: userProfileList[tag].id)
        
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .coverVertical
        tabBarController.changeRootViewController()
        
    }
    
}

extension MoreViewController: UITableViewDelegate {
    
}
extension MoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreViewTableCell.identifier, for: indexPath) as? MoreViewTableCell else { fatalError() }
        cell.tag = indexPath.row
        cell.textLabel?.text = moreViewData[indexPath.row]
        cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.imageView?.image = UIImage(named: moreViewImage[indexPath.row])
        cell.delegate = self
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}

extension MoreViewController: MoreViewTableCellDelegate {
    func didTapMoreTapButton(cell: MoreViewTableCell) {
        switch cell.tag {
        case 0:
            print("내가찜한컨텐츠 컨트롤러 연결하기")
        //네비로 바꾸기
        case 1:
            let appSettingVC = AppSetUpViewController()
            navigationController?.pushViewController(appSettingVC, animated: true)
            //            let navi = UINavigationController(rootViewController: appSettingVC)
            //            present(navi, animated: true)
            //            navigationController?.pushViewController(appSettingVC, animated: true)
            
        default:
            break
        }
    }
}
extension MoreViewController: ProfileManageButtonDelegate {
    func didTapMoreProfileButton() {
        let profileVC = ProfileViewController(root: .manager)
        let navi = UINavigationController(rootViewController: profileVC)
        present(navi, animated: true)
    }
    
    
}
extension MoreViewController: MoreAddProfileButtonViewDelegate {
    func addProfileButtonDidTap() {
         imageSetting()
    }
    
   
}


