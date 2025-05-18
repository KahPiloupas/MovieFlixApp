//
//  ImageCache.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private var activeTasks: [String: URLSessionDataTask] = [:]
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func getImageFromCache(urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        if let existingTask = activeTasks[urlString] {
            return existingTask
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    self?.activeTasks.removeValue(forKey: urlString)
                }
            }
            
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        activeTasks[urlString] = task
        task.resume()
        
        return task
    }
    
    func cancelImageLoad(for urlString: String) {
        activeTasks[urlString]?.cancel()
        activeTasks.removeValue(forKey: urlString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
} 
