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

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct APIManager {
    
    @discardableResult
    func request(
        url: URL,
        method: APIMethod,
        token: String? = nil,
        body: Data? = nil,
        completionHandler: @escaping (Result<Data, Error>) -> Void ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body
        if let token = token {
            request.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
        }
        print(request)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
        return task
    }
    
//    // GET Request
//    @discardableResult
//    func requestOfGet(
//        url: APIURL,
//        data: [String: String] = [:],
//        token: String? = nil,
//        pathItems: [PathItem] = [],
//        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
//
//        var urlString = url.rawValue
//
//        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
//        urlString += pathItem
//
//        guard var urlComponents = URLComponents(string: urlString) else {
//            completion(.failure(APIError.badURL))
//            return nil
//        }
//        var queryItems: [URLQueryItem] = []
//
//        for (key, value) in data {
//            let queryItem = URLQueryItem(name: key, value: value)
//            queryItems.append(queryItem)
//        }
//        urlComponents.queryItems = queryItems
//
//        guard let url = urlComponents.url else {
//            completion(.failure(APIError.badURL))
//            return nil
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let token = token {
//            request.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
//        }
//        print(request)
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else{
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//
//        }
//
//        task.resume()
//        return task
//
//    }
//
//
//    //Post Request
//    @discardableResult
//    func requestOfPost(
//        url: APIURL,
//        data: Data? = nil,
//        token: String? = nil,
//        pathItems: [PathItem] = [],
//        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
//
//        var urlString = url.rawValue
//
//        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
//        urlString += pathItem
//
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.badURL))
//            return nil
//        }
//
//
//        //        print(data)
//
//        var request = URLRequest(url: url, timeoutInterval: .infinity)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let token = token { request.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")}
//
//        if let data = data { request.httpBody = data }
//
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//
//        }
//
//        task.resume()
//        return task
//
//    }
//
//    @discardableResult
//    func requestOfPatch(
//        url: APIURL,
//        data: Data,
//        token: String,
//        pathItems: [PathItem] = [],
//        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?  {
//
//        var urlString = url.rawValue
//
//        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
//
//        urlString += pathItem
//
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.badURL))
//            return nil
//        }
//        var request = URLRequest(url: url)
//
//        request.httpMethod = "PATCH"
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
//        request.httpBody = data
//        print(request)
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//
//        }
//
//        //               task.resume()
//        return task
//    }
//
//    @discardableRe'sult
//    func requestOfDelete(
//        url: APIURL,
//        token: String,
//        pathItems: [PathItem] = [],
//        completion: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask? {
//
//        var urlString = url.rawValue
//
//        let pathItem = pathItems.reduce("", { $0 + $1.name + "/" + $1.value + "/" })
//
//        urlString += pathItem
//
//        guard let url = URL(string: urlString) else { return nil }
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("TOKEN " + token, forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//
//        }
//
//        task.resume()
//        return task
//
//    }
//
    
}
