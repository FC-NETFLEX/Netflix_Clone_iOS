//
//  URLExtension.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/17.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

extension URL {
    
    static func safetyURL(string: String) -> URL?  {
        if let url = URL(string: string) {
            return url
        }
        guard let decodedString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil}
        let url = URL(string: decodedString)
        return url
    }
    
}
