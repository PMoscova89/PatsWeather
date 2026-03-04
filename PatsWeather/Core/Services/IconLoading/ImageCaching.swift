//
//  ImageCaching.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import UIKit

protocol ImageCaching {
    func image(forKey key: String) -> UIImage?
    func insert(_ image: UIImage, forKey key: String)
    func removeImage(forKey key: String)
}
