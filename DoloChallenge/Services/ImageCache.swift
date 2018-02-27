//
//  ImageCache.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit

// Obtains location icons from FourSquare (based on input URL), or from the cache if already retrieved.

class ImageCache {
    
    static let instance = ImageCache()
    
    var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    func getImage(url: String, completion: @escaping (UIImage) -> ()) {
        if let image = imageCache.object(forKey: url as NSString) {
            completion(image)
        } else {
            URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    if let image = UIImage(data: data!) {
                        self.imageCache.setObject(image, forKey: url as NSString)
                        completion(image)
                    }
                })
            }).resume()
        }
    }
    
    func purgeCache() {
        imageCache.removeAllObjects()
    }
}
