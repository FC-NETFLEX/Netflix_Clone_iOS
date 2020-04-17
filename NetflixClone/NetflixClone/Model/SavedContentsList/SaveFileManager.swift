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
            let path: FileManager.SearchPathDirectory
            switch self.saveType {
            case .profileImage:
                path = .picturesDirectory
            case .movie, .movieImage:
                path = .moviesDirectory
            }
            let url = self.manager.urls(for: path, in: .userDomainMask).first
//            print("SuperURL:", url ?? "Don't Have")
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
            try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: .producesRelativePathURLs)
//            print("Check Saved Contets", contents)
        } catch {
            print(error.localizedDescription)
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
        print("====================move file==============================")
        print(saveURL)
        print(tempURL)
        print("====================move file==============================")
        deleteFile(url: saveURL)
        
        do {
            try manager.moveItem(at: tempURL, to: saveURL)
            print("Move Item: Success", fileName + "." + saveType.pathExtension())
            deleteFile(url: tempURL)
            return saveURL
        } catch {
            print("Move item Error:", error.localizedDescription)
            deleteFile(url: tempURL)
            return nil
        }
    }
    
    func deleteFile(url: URL) {
        do {
            try manager.removeItem(at: url)
            print("Delete file: Success")
        } catch {
            print("Delete file Error:", error.localizedDescription)
        }
    }
    
}
