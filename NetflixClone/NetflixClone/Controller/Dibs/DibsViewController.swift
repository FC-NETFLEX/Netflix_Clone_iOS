//
//  DibsViewController.swift
//  NetflixClone
//
//  Created by YoujinMac on 2020/04/27.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit
import SnapKit

class DibsViewController: UIViewController {
    
    private let decoder = JSONDecoder()
    
    private let dibsView = DibsView()
    private let dibsViewFlowLayout = FlowLayout(itemsInLine: 3, linesOnScreen: 3.5)
    private var dibsViewContents = [DibsContent]()
    private let dibsURL = URL(string: "https://netflexx.ga/profiles/\(LoginStatus.shared.getProfileID() ?? 48)/contents/selects/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
        setNavigation()
        setUI()
        setConstraints()
    }
    private func setNavigation() {
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .setNetfilxColor(name: .black)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.dynamicFont(fontSize: 15, weight: .regular)]
        
        let backButton = UIBarButtonItem(image: UIImage(named: "백"), style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .setNetfilxColor(name: .white)
        
        navigationItem.leftBarButtonItem = backButton
        
        title = "내가 찜한 콘텐츠"
        
    }
    
    private func request() {
        //request
        //request객체로
        
        guard let token = LoginStatus.shared.getToken() else { return }
        var urlRequest = URLRequest(url: dibsURL!)
        urlRequest.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //                let dataTask = URLSession.shared.dataTask(with: self.dibsURL!) { (data, response, error) in
            print(" DibsView dataTask 입성")
            
            print("dibURL -> \(self.dibsURL)")
            
            guard error == nil else { return print("error:", error!) }
            guard let response = response as? HTTPURLResponse else { return print("response 오류")}
            guard (200..<400).contains(response.statusCode) else { return print("response statusCode \(response.statusCode) \n파싱 종료") }
            guard let data = data else { return  print("jsonPassing data 오류") }
            
            do {
                let jsonData = try self.decoder.decode([DibsContent].self, from: data)
                print("----------------[ DibsView jsonData 파싱시작 ]--------------------")
                self.dibsViewContents = jsonData
                
                DispatchQueue.main.async {
                    self.dibsView.collectionView.reloadData()
                }
                
                print("----------------[ DibsView jsonData 파싱종료 ]--------------------")
                
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    //MARK: UI
    private func setUI() {
        view.backgroundColor = .setNetfilxColor(name: .black)
  
        //DibsView 관련
        dibsView.collectionView.delegate = self
        dibsView.collectionView.dataSource = self
        view.addSubview(dibsView)
        
    }
    
    private func setConstraints() {
        let guide = self.view.safeAreaLayoutGuide
        
        dibsView.snp.makeConstraints {
            $0.top.equalTo(guide.snp.top)
            $0.bottom.equalTo(guide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    @objc func backButtonDidTap() {
           navigationController?.popViewController(animated: true)
       }
    
}

//MARK: CollectionView DataSource
extension DibsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dibsViewContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dibsView.collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBasicItem.identifier, for: indexPath) as! ContentsBasicItem
        
        cell.jinConfigure(urlString: dibsViewContents[indexPath.row].imageURL)
        
        return cell
    }
}

//MARK: CollectionView Delegate
extension DibsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return dibsViewFlowLayout.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dibsViewFlowLayout.linesOnScreen
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dibsViewFlowLayout.itemSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return setDibsViewFlowLayout()
    }
    
    
    func setDibsViewFlowLayout() -> CGSize {
        let itemSpacing = dibsViewFlowLayout.itemSpacing * (dibsViewFlowLayout.itemsInLine - 1) //
        let lineSpacing = dibsViewFlowLayout.lineSpacing * (dibsViewFlowLayout.linesOnScreen - 1) // 5 * 2.5
        let horizontalInset = dibsViewFlowLayout.edgeInsets.left + dibsViewFlowLayout.edgeInsets.right
        let verticalInset = dibsViewFlowLayout.edgeInsets.top + dibsViewFlowLayout.edgeInsets.bottom
        
        let horizontalSpacing = itemSpacing + horizontalInset
        let verticalSpacing = lineSpacing + verticalInset
        
        let contentWidth = dibsView.collectionView.frame.width - horizontalSpacing
        let contentHeight = dibsView.collectionView.frame.height - verticalSpacing
        let width = contentWidth / dibsViewFlowLayout.itemsInLine
        let height = contentHeight / dibsViewFlowLayout.linesOnScreen
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down) - 1)
    }
}
