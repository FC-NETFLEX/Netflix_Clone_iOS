//
//  APIURL.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/31.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation


enum APIURL: String {
    case createUser = "http://13.124.222.31/members/"
    case logIn = "http://13.124.222.31/members/auth_token/"
    case logOut = "http://13.124.222.31/members/logout/"
    case iconList = "http://13.124.222.31/members/profiles/icons/"
}
