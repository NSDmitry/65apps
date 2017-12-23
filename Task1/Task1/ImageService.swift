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
    var tasks = [URL: URLSessionTask]()
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(image)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                switch error {
                case URLError.notConnectedToInternet:
                    print("Internet connection")
                default:
                    print("Unknow error")
                }
                self.tasks[url] = nil
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: url as AnyObject)
                completion(image)
            }
        })
        task.resume()
        tasks[url] = task
    }
    
    func cancellTask(url: URL) {
        guard let task = tasks[url] else { return }
        task.cancel()
        tasks[url] = nil
    }
}
