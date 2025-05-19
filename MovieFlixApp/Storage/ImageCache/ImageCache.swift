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
    private let taskLock = NSLock()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearMemoryCache),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc private func clearMemoryCache() {
        cache.removeAllObjects()
    }
    
    func getImageFromCache(urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    #if DEBUG
    // Helper for testing
    func setImageInCache(_ image: UIImage, for urlString: String) {
        cache.setObject(image, forKey: urlString as NSString)
    }
    #endif
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        taskLock.lock()
        if let existingTask = activeTasks[urlString] {
            taskLock.unlock()
            return existingTask
        }
        
        guard let url = URL(string: urlString) else {
            taskLock.unlock()
            completion(nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    self?.taskLock.lock()
                    self?.activeTasks.removeValue(forKey: urlString)
                    self?.taskLock.unlock()
                }
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data,
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
        taskLock.unlock()
        task.resume()
        
        return task
    }
    
    func cancelImageLoad(for urlString: String) {
        taskLock.lock()
        activeTasks[urlString]?.cancel()
        activeTasks.removeValue(forKey: urlString)
        taskLock.unlock()
    }
    
    func clearCache() {
        cache.removeAllObjects()
        
        taskLock.lock()
        for task in activeTasks.values {
            task.cancel()
        }
        activeTasks.removeAll()
        taskLock.unlock()
    }
}
