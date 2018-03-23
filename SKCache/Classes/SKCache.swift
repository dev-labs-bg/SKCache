//
//  SKCache.swift
//  Pods-SKCache_Example
//
//  Created by Steliyan H. on 3.11.17.
//

import UIKit

/// Enum to hold possible errors during execution of methods over SKCache
///
/// - fetchFail: Failed to fetch an object
/// - deletaFail: Failed to delete an object
/// - saveFail: Failed to save an object
/// - loadFail: Failed to load the SKCache
public enum Operations: Swift.Error {
  case fetchFail
  case deletaFail
  case saveFail
  case loadFail
}

/// Enum to indicate the live time of each time in the cache
///
/// - never: option to never expire the cache object
/// - everyDay: option to expire at the end of the day
/// - everyWeek: option to expiry after a week
/// - everyMonth: option to set the expiry date each month
/// - seconds: option to set the expiry after some seconds
public enum ExpiryDate {
  case never
  case everyDay
  case everyWeek
  case everyMonth
  case seconds(TimeInterval)
  
  /// Property to return the actual expiration date
  public var date: Date {
    switch self {
    case .never:
      
      return Date.distantFuture
    case .everyDay:
      
      return endOfDay
    case .everyWeek:
      
      return date(afterDays: 7)
    case .everyMonth:
      
      return date(afterDays: 30)
    case .seconds(let seconds):
      
      return Date().addingTimeInterval(seconds)
    }
  }
  
  /// Method to return a date after given days
  ///
  /// - Parameter afterDays: The days after which a dtae will be returned
  /// - Returns: The date after adding the days
  private func date(afterDays days: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
  }
  
  /// Property to return the end time of a day
  private var endOfDay: Date {
    let startOfDay = Calendar.current.startOfDay(for: Date())
    var components = DateComponents()
    components.day = 1
    components.second = -1
    
    return Calendar.current.date(byAdding: components, to: startOfDay) ?? Date()
  }
  
}

public class SKCache: NSCache<AnyObject, AnyObject> {
  
  // MARK: - Singleton properties
  
  /// Public property to access a shared instance of the cache
  open static var shared: SKCache {
    struct Static {
      static var instance = SKCache() {
        didSet {
          Static.instance.countLimit = SKCache.elementsCount
          Static.instance.totalCostLimit = SKCache.elementsCostLimit
        }
      }
    }
    
    return Static.instance
  }
  
  // MARK: - Static properties
  
  /// Static property to store the count of element stored in the cache (by default it is 100)
  open static var elementsCount = 100
  
  /// Static property to store the cost limit of the cache (by default it is 0)
  open static var elementsCostLimit = 0
  
  // MARK: - Public properties
  
  /// Public property to store the expiration date of each object in the cache (by default it is set to .never)
  open var expiration: ExpiryDate = .never
  
  // MARK: - Public methods
  
  /// Public method to add an object to the cache
  ///
  /// - Parameter object: The object which will be added to the cache
  open func add(object: SKObject) {
    var objects = SKCache.shared.object(forKey: cacheKey as AnyObject) as? [SKObject]

    if objects?.contains(where: { $0.key == object.key }) == false {
      objects?.append(object)
      
      SKCache.shared.setObject(objects as AnyObject, forKey: SKCache.shared.cacheKey as AnyObject)
    } else {
      update(object: object)
    }
  }
  
  /// Public method to return an object from the cache by a given key
  ///
  /// - Parameter key: The key of the searched object
  /// - Returns: The object found under the given key ot nil
  open func get<T>(forKey key: String) -> T? {
    let objects = SKCache.shared.object(forKey: cacheKey as AnyObject) as? [SKObject]
    
    let objectsOfType = objects?.filter({ $0.value is T })
    
    return objectsOfType?.filter({ $0.key == key }).first?.value as? T
  }
  
  /// Public method to update an existing object
  ///
  /// - Parameter object: The new object
  open func update(object: SKObject) {
    var objects = SKCache.shared.object(forKey: cacheKey as AnyObject) as? [SKObject]
    
    if let index = objects?.index(where: { $0.key == object.key }) {
      objects?.remove(at: index)
      objects?.append(object)
    }
    
    SKCache.shared.setObject(objects as AnyObject, forKey: SKCache.shared.cacheKey as AnyObject)
  }
  
  /// Public method to save all cache content to the disk
  ///
  /// - Throws: An error if such occures during save
  open func save() throws {
    let objects = SKCache.shared.object(forKey: cacheKey as AnyObject) as? [SKObject] ?? [SKObject]()
    let fileManager = FileManager.default
    do {
      let cacheDirectory = try fileManager.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
      let fileDirectory = cacheDirectory.appendingPathComponent("spacekit")
      
      var isDirectory: ObjCBool = false
      
      var fileDir = fileDirectory.absoluteString
      let range = fileDir.startIndex..<fileDir.index(fileDir.startIndex, offsetBy: 7)
      fileDir.removeSubrange(range)
      
      if !fileManager.fileExists(atPath: fileDir, isDirectory: &isDirectory) {
        try fileManager.createDirectory(at: fileDirectory, withIntermediateDirectories: false, attributes: nil)
      }
      
      for object in objects {
        let fileFormatedName = object.key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? object.key
        let fileName = fileDirectory.appendingPathComponent(fileFormatedName)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        
        try? data.write(to: fileName)
      }
      
      SKCache.shared.setObject([SKObject]() as AnyObject, forKey: SKCache.shared.cacheKey as AnyObject)
      
    } catch {
      throw Operations.saveFail
    }
  }
  
  /// Public method to load all object from disk to memory
  ///
  /// - Throws: An error if such occures during load
  open func load() throws {
    let fileManager = FileManager.default
    do {
      let cacheDirectory = try fileManager.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
      var fileDirectory = cacheDirectory.appendingPathComponent("spacekit").absoluteString
      let range = fileDirectory.startIndex..<fileDirectory.index(fileDirectory.startIndex, offsetBy: 7)
      fileDirectory.removeSubrange(range)
      
      let paths = try fileManager.contentsOfDirectory(atPath: fileDirectory)
      
      for path in paths {
        if let object = NSKeyedUnarchiver.unarchiveObject(withFile: fileDirectory + path) as? SKObject {
          if !object.isExpired {
            SKCache.shared.add(object: object)
          } else {
            try? fileManager.removeItem(atPath: fileDirectory + path)
          }
        }
      }
    } catch {
      throw Operations.loadFail
    }
  }
  
  // MARK: - Initialize/Livecycle methods
  
  override init() {
    super.init()
    
    setObject([SKObject]() as AnyObject ,forKey: cacheKey as AnyObject)
  }
  
  // MARK: - Override methods
  
  // MARK: - Private properties
  
  /// read only private property to store the identifier of the read/write queue
  private let cacheKey = Bundle.main.bundleIdentifier ?? ""
  
  // MARK: - Private methods
  
}

