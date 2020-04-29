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

struct Profile {
    let id: Int
    let name: String
    let imageURL: URL
}

struct LoginStatus {
    static var shared = LoginStatus()
    private var user: User?
    
    private var profile: Profile?
    
    private let tokenKey = "user"
    
    // 토큰을 받아서 싱글톤에 할당 후 유저 디폴츠에 저장
    mutating func login(user: User) {
        self.user = user
        guard let data = try? JSONEncoder().encode(user)
            else {
            print("Login Encoding Fail")
            return
        }
        UserDefaults.standard.set(data, forKey: tokenKey)
        print("==========================Login===================================")
        print("email:", user.email)
        print("token:", user.token)
        print("============================Login=================================")
    }
    
    // 싱글톤의 토큰, 프로필 아이디에 nil을 할당하고 유저 디폴츠에 값을 삭제
    mutating func logout() {
        user = nil
        profile = nil
        UserDefaults.standard.set(nil, forKey: tokenKey)
    }
    
    // 싱들톤의 프로필 아이디에 할당
    mutating func selectedProfile(profile: Profile) {
        self.profile = profile
        print("profileID=============================================================")
        print("Login:", profile)
        print("profileID=============================================================")
    }
    
    // 유저 디폴츠에 아이디가 저장 되어있는지 확인후 Bool 타입으로 반환
    mutating func checkLoginStatus() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: tokenKey) else { return false }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return false}
        self.user = user
        print("============================Login=================================")
        print("email:", user.email)
        print("token:", user.token)
        print("===============================Login==============================")
        return true
    }
    
    // 토큰값을 반환
    func getToken() -> String? {
        self.user?.token
    }
    
    // 이메일 반환
    func getEmail() -> String? {
        self.user?.email
    }
    
    func getUser() -> User? {
        self.user
    }
    
    // 프로필 아이디를 반환
    func getProfileID() -> Int? {
        self.profile?.id
    }
    
    func getProfile() -> Profile? {
        self.profile
    }
    
    
}
