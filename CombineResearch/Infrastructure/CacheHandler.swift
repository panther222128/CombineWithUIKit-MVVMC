//
//  CacheHandler.swift
//  CombineResearch
//
//  Created by Horus on 2/2/24.
//

import Foundation

enum CacheHandlerError: Error {
    case readFailed
}

final class CacheHandler {
    
    static let shared = CacheHandler()
    
    private let imageDataCache = NSCache<NSNumber, NSData>()
    
    init() {
        
    }
    
    func addToCache(key: Int, data: Data) {
        let key = key as NSNumber
        let data = data as NSData
        imageDataCache.setObject(data, forKey: key)
    }
    
    func readFromCache(with key: Int) -> Data? {
        let key = key as NSNumber
        if let data = imageDataCache.object(forKey: key) as? Data {
            return data
        } else {
            return nil
        }
    }
    
}
