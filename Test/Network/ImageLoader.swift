//
//  RequestManager.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import UIKit

struct ImageLoader {
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    static func loadImage(from urlString: String, responseHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error?) -> Void) {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            responseHandler(imageFromCache)
            return
        }
        guard let url = URL(string: urlString) else { errorHandler(nil); return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let dataResult = data else { errorHandler(error); return }
            
            if error != nil {
                errorHandler(error)
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                errorHandler(nil)
                return
            }

            if let image = UIImage(data: dataResult) {
                imageCache.setObject(image, forKey: urlString as AnyObject)
                responseHandler(image)
            } else {
                errorHandler(nil)
            }
        }).resume()
    }
}
