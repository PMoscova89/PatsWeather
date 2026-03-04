//
//  InMemoryImageCache.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import UIKit

final class InMemoryImageCache: ImageCaching {

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func insert(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    
}
