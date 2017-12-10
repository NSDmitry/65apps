//
//  ImageService.swift
//  Task1
//
//  Created by D. Serov on 10/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import UIKit

class ImageService {
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(image)
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, _, error) in
            if let error = error {
                switch error {
                case URLError.notConnectedToInternet:
                    print("Internet connection")
                default:
                    print("Unknow error")
                }
                completion(nil)
            }
            
            let image = UIImage(data: data!)
            self.imageCache.setObject(image!, forKey: url as AnyObject)
            completion(image)
        }).resume()
    }
}
