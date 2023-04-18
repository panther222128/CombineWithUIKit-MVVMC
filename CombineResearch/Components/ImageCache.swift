//
//  CachedImageView.swift
//  CombineResearch
//
//  Created by Horus on 2023/03/09.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private var cache: NSCache<NSString, UIImage> = NSCache()
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func image(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }
        task.resume()
    }
    
}
