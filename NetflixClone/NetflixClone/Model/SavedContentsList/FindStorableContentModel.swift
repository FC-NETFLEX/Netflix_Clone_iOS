//
//  FindStorableContentModel.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/23.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


protocol FindStorableContentModelDelegate: class {
    func categorysDidChange()
}

class FindStorableContentModel {
    
    weak var delegate: FindStorableContentModelDelegate?
    var categorys: [StorableCategory] = [] {
        didSet {
            delegate?.categorysDidChange()
        }
    }
    
    let categorymNames = ["1": "드라마", "2": "판타지", "3": "서부", "4": "공포", "5": "로맨스", "6": "모험", "7": "스릴러", "8": "느와르", "9": "컬트",  "10": "다큐멘터리", "11": "코미디", "12": "가족", "13": "미스터리", "14": "전쟁", "15": "애니메이션", "16": "범죄", "17": "뮤지컬", "18": "SF", "19": "액션", "20": "무협", "21": "에로", "22": "서스펜스", "23": "서사", "24": "블랙코미디", "25": "실험", "26": "영화카툰", "27": "영화음악", "28": "영화패러디포스터"]
    
    init(delegate: FindStorableContentModelDelegate) {
        self.delegate = delegate
        requestStorableContens()
    }
    
    private func requestStorableContens() {
        guard let profileID = LoginStatus.shared.getProfileID() else { return }
        let pathItems = [
            Path(name: APIPathKey.profiles, value: String(profileID)),
            Path(name: APIPathKey.save, value: nil),
        ]
        guard let url = APIURL.defaultURL.getURL(path: pathItems, queryItems: nil) else { return }
        APIManager().request(url: url, method: .get, token: LoginStatus.shared.getToken(), body: nil, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                guard let categorys = try? JSONDecoder().decode([StorableCategory].self, from: data) else { return }
                self?.categorys = categorys
            }
        })
    }
    
}

struct StorableCategory: Decodable {
    let categoryID: String
    let contents: [StorableContent]
    
    private enum CodingKeys: String, CodingKey {
        case categoryID = "category_name"
        case contents
    }
}

struct StorableContent: Decodable {
    let contentID: Int
    let title: String
    let imageURLString: String
    
    private enum CodingKeys: String, CodingKey {
        case contentID = "id"
        case title = "contents_title"
        case imageURLString = "contents_image"
    }
}



