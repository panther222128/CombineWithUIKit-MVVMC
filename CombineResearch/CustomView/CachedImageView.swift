//
//  CachedImageView.swift
//  CombineResearch
//
//  Created by Horus on 2023/03/09.
//

import UIKit

final class CachedImageView: UIImageView {
    
    private let imageCache = NSCache<NSString, UIImage>()
    private var imageURLString: String?
    
    func loadImage(with urlString: String) {
        self.imageURLString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.image = nil
            }
            DispatchQueue.main.async {
                guard let data = data else { return }
                guard let dataImage = UIImage(data: data) else { return }
                if self.imageURLString == urlString {
                    self.image = dataImage
                }
                self.imageCache.setObject(dataImage, forKey: urlString as NSString)
            }
        }.resume()
    }

}
