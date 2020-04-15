//
//  LoginStatus.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

struct User: Codable {
    let email: String
    let token: String
}

struct LoginStatus {
    static var shared = LoginStatus(email: nil, token: nil, profileID: nil)
    private var email: String?
    private var token: String?
    private var profileID: Int?
    private let tokenKey = "user"
    
    // 토큰을 받아서 싱글톤에 할당 후 유저 디폴츠에 저장
    mutating func login(email: String, token: String) {
        self.token = token
        self.email = email
        let user = User(email: email, token: token)
        guard let data = try? JSONEncoder().encode(user)
            else {
            print("Login Encoding Fail")
            return
        }
        UserDefaults.standard.set(data, forKey: tokenKey)
        print("==========================Login===================================")
        print("email:", email)
        print("token:", token)
        print("============================Login=================================")
    }
    
    // 싱글톤의 토큰, 프로필 아이디에 nil을 할당하고 유저 디폴츠에 값을 삭제
    mutating func logout() {
        token = nil
        profileID = nil
        UserDefaults.standard.set(nil, forKey: tokenKey)
    }
    
    // 싱들톤의 프로필 아이디에 할당
    mutating func selectedProfile(profileID: Int) {
        self.profileID = profileID
        print("profileID=============================================================")
        print("Login:", profileID)
        print("profileID=============================================================")
    }
    
    // 유저 디폴츠에 아이디가 저장 되어있는지 확인후 Bool 타입으로 반환
    mutating func checkLoginStatus() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: tokenKey) else { return false }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return false}
        self.email = user.email
        self.token = user.token
        print("============================Login=================================")
        print("email:", user.email)
        print("token:", user.token)
        print("===============================Login==============================")
        return true
    }
    
    // 토큰값을 반환
    func getToken() -> String? {
        self.token
    }
    
    // 이메일 반환
    func getEmail() -> String? {
        self.email
    }
    
    // 프로필 아이디를 반환
    func getProfileID() -> Int? {
        self.profileID
    }
    
    
}
