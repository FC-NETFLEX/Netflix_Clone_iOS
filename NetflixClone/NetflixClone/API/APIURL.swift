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
    case defaultURL = "http://13.124.222.31/"
    
    case signUp = "http://13.124.222.31/members/"
    case logIn = "http://13.124.222.31/members/auth_token/"
    case logOut = "http://13.124.222.31/members/logout/"
    
    case iconList = "http://13.124.222.31/members/profiles/icons/"
    case makeProfile = "http://13.124.222.31/members/profiles/"
   
    
    func makeURL(pathItems: [PathItem] = []) -> URL? {
        let urlString = self.rawValue
        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
        
        return URL(string: urlString + pathItem)
    }
}
