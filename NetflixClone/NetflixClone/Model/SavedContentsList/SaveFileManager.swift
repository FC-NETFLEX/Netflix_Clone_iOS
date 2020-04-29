//
//  SaveFileManager.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

enum SaveType {
    case profileImage
    case movie
    case movieImage
    
    func pathExtension() -> String {
        switch self {
        case .movie:
            return "mp4"
        default:
            return "png"
        }
    }
}

class SaveFileManager {
    private let manager = FileManager.default
    private let saveType: SaveType
    private var superURL: URL? {
        get {
            let urls = self.manager.urls(for: .documentDirectory, in: .userDomainMask)
//            print("SuperURLs:", urls)
            guard var url = urls.first else { return nil }
            switch self.saveType {
            case .profileImage:
                url.appendPathComponent("Profile")
            case .movie, .movieImage:
                url.appendPathComponent("Video")
            }
//            print("SuperURL:", url)
            return url
        }
    }
    
    init(saveType: SaveType) {
        self.saveType = saveType
        checkDirectory()
    }
    
    private func checkDirectory() {
        guard let url = superURL else { return }
        do {
            let _ = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: .producesRelativePathURLs)
//            print("Check Saved Contets:", contents)
        } catch {
            print("Check Saved Contets Error:", error.localizedDescription)
            makeDirectory()
        }
    }
    
    private func makeDirectory() {
        guard let url = superURL else { return }
        do {
            try manager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
//            print("makeDirectory: Success")
        } catch {
            print("makeDirectory Error:", error.localizedDescription)
        }
    }
    
    func moveFile(tempURL: URL, fileName: String) -> URL? {
        guard let saveDir = superURL else { return nil}
        let saveURL = saveDir.appendingPathComponent(fileName).appendingPathExtension(saveType.pathExtension())
//        print("====================move file==============================")
//        print(saveURL)
//        print(tempURL)
//        print("====================move file==============================")
        deleteFile(url: saveURL)
        
        do {
            try manager.moveItem(at: tempURL, to: saveURL)
//            print("Move Item: Success", fileName + "." + saveType.pathExtension())
            deleteFile(url: tempURL)
            return saveURL
        } catch {
            print("Move item Error:", error.localizedDescription)
            deleteFile(url: tempURL)
            return nil
        }
    }
    
    func readFile(contentID: Int) -> URL?{
        
        guard let directory = superURL else { print("ReadFile:", "Failed"); return nil }
        
        guard let contetnts = try? manager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [], options: .producesRelativePathURLs) else { print("ReadFile:", "Failed"); return nil }
        
        guard let index = contetnts.firstIndex(where: {
            $0.lastPathComponent == String(contentID) + "." + saveType.pathExtension()
        }) else { return nil }
        
        let resultURL = contetnts[index]
//        print("ReadFile: Success", "\nURL:", resultURL)
        return resultURL
    }
    
    func deleteFile(url: URL) {
        do {
            try manager.removeItem(at: url)
            print("Delete file: Success")
            print(url)
        } catch {
            print("Delete file Error:", error.localizedDescription)
        }
    }
    
}
