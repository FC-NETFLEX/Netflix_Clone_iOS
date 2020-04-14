//
//  APIURL.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/31.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

typealias PathItem = (name: String, value: String)

enum APIURL: String {
    case defaultURL = "https://www.netflexx.ga"
    
    case signUp = "https://www.netflexx.ga/members/"
    case logIn = "https://www.netflexx.ga/members/auth_token/"
    case logOut = "https://www.netflexx.ga/members/logout/"
    
    case iconList = "https://www.netflexx.ga/members/profiles/icons/"
    case makeProfile = "https://www.netflexx.ga/members/profiles/"
   
    
    func makeURL(pathItems: [PathItem] = []) -> URL? {
        let urlString = self.rawValue
        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
        
        return URL(string: urlString + pathItem)
    }
}
