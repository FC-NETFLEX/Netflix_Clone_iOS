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
    private let profileButton = ProfileManageButton()
    private let moreTableView = UITableView(frame: .zero, style: .grouped)
 
    
    private var userProfileList = [ProfileList]()
    private var userIconList = [ProfileIcons]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     print(userArray)
        reqeustProfileList()
        setNavigation()
        
    }
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
  
    private func profileStactViewSetting() {
   
        guard let profile = LoginStatus.shared.getProfile() else { return }
        
        let count = userProfileList.count
        for (index, user) in userProfileList.enumerated() {
            let tempProfileView = MorePofileView()
            tempProfileView.delegate = self
            if user.id == profile.id {
                tempProfileView.selectProfile()
            }
            
            tempProfileView.tag = index
            tempProfileView.profileLabel.text = user.name
            let button = tempProfileView.profileButton
            setImage(stringURL: userIconList[index].iconURL, button: button)
            stackView.addArrangedSubview(tempProfileView)
//                userArray.append(tempProfileView)
            
            tempProfileView.snp.makeConstraints {
                $0.width.equalTo(view.snp.width).multipliedBy(0.15)
//                    equalToSuperview().multipliedBy(0.17)
                $0.height.equalToSuperview()
                $0.top.equalToSuperview()
            }
        }
        
        if count < 5 {
            let tempAddView = MoreAddProfileButtonView()
            stackView.addArrangedSubview(tempAddView)
            tempAddView.delegate = self
            tempAddView.snp.makeConstraints {
                $0.width.equalTo(view.snp.width).multipliedBy(0.17)
                //                    $0.width.equalToSuperview().multipliedBy(0.18)
                $0.height.equalToSuperview()
                $0.top.equalToSuperview()
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
        [stackView,profileButton,moreTableView].forEach {
            view.addSubview($0)
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        
        
        profileButton.delegate = self
        
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.separatorColor = .setNetfilxColor(name: .black)
        moreTableView.backgroundColor = .setNetfilxColor(name: .black)
        moreTableView.register(MoreViewTableCell.self, forCellReuseIdentifier: MoreViewTableCell.identifier)
        
    }
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        let topMargin: CGFloat = 55
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topMargin)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.125)
        }
        profileButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalTo(guide)
            $0.height.equalToSuperview().multipliedBy(0.08)
        }
        moreTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(profileButton.snp.bottom)
            $0.bottom.equalTo(guide.snp.bottom)
            
        }
    }
    private func customerCenterScheme() {
        guard
            let url = URL(string: "https://help.netflix.com/ko"),
            UIApplication.shared.canOpenURL(url)
            else { return }
        
        UIApplication.shared.open(url)
        
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

            DispatchQueue.main.async {

                for view in self.stackView.subviews {
                    view.removeFromSuperview()

                }
            }
            
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

    private func imageSetting() {
        
        let addVC = AddProfileViewController(root: .manager)
        
        switch userIconList.isEmpty {
        case true:
            addVC.randomSetImage = "https://fc-netflex.s3.ap-northeast-2.amazonaws.com/profile/icon/icon3.png"
            addVC.randomIndex = 3
            
        case false:
            guard let imageIndex = (0..<self.userIconList.count).randomElement() else { return }
            addVC.randomSetImage = self.userIconList[imageIndex].iconURL
            addVC.randomIndex = self.userIconList[imageIndex].idNum
        }
        
        let navi = UINavigationController(rootViewController: addVC)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
}
extension MoreViewController: MoreProfileViewDelegate {
    func didTapSelectButton() {
        print("터치노노")
    }
    
    
    func profileButtonDidTap(tag: Int) {
        let userProfile = userProfileList[tag]
        let icon = userIconList[tag]
        guard let imageURL = URL(string: icon.iconURL) else { return }
        let id = userProfile.id
        let name = userProfile.name
        let profile = Profile(id: id, name: name, imageURL: imageURL)
        LoginStatus.shared.selectedProfile(profile: profile)
        
        let tabBarController = TabBarController()
        tabBarController.modalTransitionStyle = .coverVertical
        tabBarController.changeRootViewController()
        
    }
    
}

extension MoreViewController: UITableViewDelegate {
    
}
extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let logout = LogOutVerView()
        logout.delegate = self
        return logout
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      let logoutHeight = view.frame.height / 6
        return logoutHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let netflix = NetflixView()
        return netflix
 
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 200
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreViewTableCell.identifier, for: indexPath) as? MoreViewTableCell else { fatalError() }
    
        cell.tag = indexPath.row
        cell.textLabel?.text = moreViewData[indexPath.row]
        cell.backgroundColor = .setNetfilxColor(name: .backgroundGray)
        cell.textLabel?.textColor = .setNetfilxColor(name: .netflixLightGray)
        cell.textLabel?.font = UIFont.dynamicFont(fontSize: 14, weight: .regular)
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
            let dibsVC = DibsViewController()
//            navigationController?.isNavigationBarHidden = false
           navigationController?.pushViewController(dibsVC, animated: true)
                      
        //네비로 바꾸기
        case 1:
            let appSettingVC = AppSetUpViewController()
            navigationController?.pushViewController(appSettingVC, animated: true)
           
         case 2:
             print("계정 연결하기")
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
            
        case 3:
             print("고객센터 연결하기")
             customerCenterScheme()
        default:
            break
        }
    }
}
extension MoreViewController: ProfileManageButtonDelegate {
    func didTapMoreProfileButton() {
        let profileVC = ProfileViewController(root: .manager)
        let navi = UINavigationController(rootViewController: profileVC)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
        //present
    }
    
    
}
extension MoreViewController: MoreAddProfileButtonViewDelegate {
    func addProfileButtonDidTap() {
        imageSetting() //present
    }
    
    
}
extension MoreViewController: LogOutVerViewDelegate {
    func didTapLogoutButton() {
        alertAction()
    }

}


