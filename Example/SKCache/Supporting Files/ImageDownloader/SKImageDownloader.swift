//
//  SKImageDownloader.swift
//  SpaceKit
//
//  Created by Steliyan H. on 25.10.17.
//  Copyright © 2017 DevLabs. All rights reserved.
//

import UIKit
import SKCache

typealias SKImageDownloaderCompletion = (_ image: UIImage?, _ error: Error?) -> ()

class SKImageDownloader: NSObject {
  
  // MARK: - Singleton properties
  
  // MARK: - Static properties
  
  static var shared: SKImageDownloader {
    struct Static {
      static let instance = SKImageDownloader()
    }
    
    return Static.instance
  }
  
  // MARK: - Public properties
  
  /// Public property to store the timeout interval for each download task
  open var timeOut: TimeInterval = 10.0
  
  // MARK: - Public methods
  
  internal func loadImage(forUrl url: String?, placeholder: UIImage? = nil, completion: @escaping SKImageDownloaderCompletion) {
    
    guard let urlString = url, let url = URL(string: urlString) else {
      DispatchQueue.main.async {
        completion(placeholder, nil)
      }
      
      return
    }
    let decomposedString = urlString.replacingOccurrences(of: "/", with: "")
    
    let cachedImage: UIImage? = SKCache.shared.get(forKey: decomposedString)
    
    if cachedImage == nil {
      var urlRequest = URLRequest(url: url)
      urlRequest.timeoutInterval = timeOut
      var task = URLSessionDataTask()
      task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        
        if let index = self.queue.firstIndex(of: task) {
          self.queue.remove(at: index)
        }
        
        guard let imageData = data else {
          DispatchQueue.main.async {
            completion(placeholder, error)
          }
          
          return
        }
        if let image = UIImage(data: imageData) {
          let cacheObject = SKObject(value: image, key: decomposedString)
          
          SKCache.shared.add(object: cacheObject)
          
          DispatchQueue.main.async {
            completion(image, error)
          }
        } else {
          DispatchQueue.main.async {
            completion(placeholder, error)
          }
        }
      }
      
      queue.append(task)
      
      task.resume()
    } else {
      DispatchQueue.main.async {
        completion(cachedImage, nil)
      }
    }
  }
  
  /// Public method to cancel all active downloads
  internal func cancelAllDownloads() {
    queue.forEach({ $0.cancel() })
  }
  
  /// Public method to cancel a request for a given url
  ///
  /// - Parameter url: The url of the request which will be canceled
  internal func cancelTask(forUrl url: String) {
    if let task = queue.filter({ $0.originalRequest?.url?.absoluteString == url }).first {
    
      if task.state == .running {
        task.cancel()
        
        if let index = queue.firstIndex(of: task) {
          queue.remove(at: index)
        }
      }
    }
  }
  
  // MARK: - Initialize/Livecycle methods
  
  // MARK: - Override methods
  
  // MARK: - Private properties
  
  /// Private property to store all curently active tasks
  private var queue = [URLSessionDataTask]()
  
  // MARK: - Private methods

}
