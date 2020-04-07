//
//  LoginStatus.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/03/25.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

struct LoginStatus {
    static var shared = LoginStatus(token: nil, profileID: nil)
    private var token: String?
    private var profileID: Int?
    private let tokenKey = "userToken"
    
    // 토큰을 받아서 싱글톤에 할당 후 유저 디폴츠에 저장
    mutating func login(token: String) {
        self.token = token
        UserDefaults.standard.set(token, forKey: tokenKey)
        print("=============================================================")
        print("Login:", token)
        print("=============================================================")
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
    }
    
    // 유저 디폴츠에 아이디가 저장 되어있는지 확인후 Bool 타입으로 반환
    mutating func checkLoginStatus() -> Bool {
        guard let token = UserDefaults.standard.string(forKey: tokenKey) else { return false }
        self.token = token
        return true
    }
    
    // 토큰값을 반환
    func getToken() -> String? {
        self.token
    }
    
    // 프로필 아이디를 반환
    func getProfileID() -> Int? {
        self.profileID
    }
    
    
}
