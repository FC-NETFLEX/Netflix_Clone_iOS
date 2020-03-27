//
//  API.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case badURL
    case failedDecoding
    case responseError
    case noData
}

enum APIURL: String {
    case createUser = "http://13.124.222.31/members/"
    case login = "http://13.124.222.31/members/login/"
}

struct APIManager {
    
    
    func requestOfPost(
        url: APIURL,
        data: Data? = nil,
        token: String? = nil,
        completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: url.rawValue) else {
            completion(.failure(APIError.badURL))
            return
        }
        
        
//        print(data)
        
        var request = URLRequest(url: url, timeoutInterval: .infinity)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = data { request.httpBody = data }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
            
        }
        
        task.resume()
        
        
    }
    
}
