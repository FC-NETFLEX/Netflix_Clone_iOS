//
//  MoreViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class MoreViewController: UIViewController {
    
    let moreTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUI()
        setConstraints()
      
    }

    private func setUI() {
        [moreTableView].forEach {
            view.addSubview($0)
        }
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(MoreViewTableCell.self, forCellReuseIdentifier: MoreViewTableCell.identifier)
    }
    private func setConstraints() {
        let margin: CGFloat = 30
        let padding: CGFloat = 4
        
        moreTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.centerY)
            $0.bottom.equalToSuperview()
            
        }
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
        cell.textLabel?.text = moreViewData[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.08149587563, green: 0.08149587563, blue: 0.08149587563, alpha: 1)
        cell.tag = indexPath.row
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
            let navi = UINavigationController(rootViewController: appSettingVC)
            present(navi, animated: true)
//            navigationController?.pushViewController(appSettingVC, animated: true)

        default:
            break
        }
    }
}

