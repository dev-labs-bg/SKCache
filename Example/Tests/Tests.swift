import UIKit
import XCTest
import SKCache

class Tests: XCTestCase {
    
  let url = URL(string: "https://www.google.com/")!
  
  let string = "Test"
  
  let set: Set<String> = ["First", "Second"]
  
  let dictionaty = ["string": "Test"]
  
  let image = #imageLiteral(resourceName: "test_image")
  
  override func setUp() {
    super.setUp()
    
    let objectString = SKObject(value: string as AnyObject, key: "string")
    SKCache.shared.add(object: objectString)
    
    let objectSet = SKObject(value: set as AnyObject, key: "set")
    SKCache.shared.add(object: objectSet)
    
    let objectDictionary = SKObject(value: dictionaty as AnyObject, key: "dictionary")
    SKCache.shared.add(object: objectDictionary)
    
    let objectUrl = SKObject(value: url as AnyObject, key: "url")
    SKCache.shared.add(object: objectUrl)
    
    let objectImage = SKObject(value: image, key: "image")
    SKCache.shared.add(object: objectImage)
    
    do {
      try SKCache.shared.save()
      try SKCache.shared.load()
    } catch {
      XCTAssertThrowsError(error.localizedDescription)
    }
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testInitialization() {
    XCTAssertNotNil(SKCache.shared)
  }
  
  func testObject() {
    let string = "Test"
    
    let object = SKObject(value: string as AnyObject, key: "string")
    XCTAssertNotNil(object)
  }
  
  func testPrimitive() {
    let cachedString: String? = SKCache.shared.get(forKey: "string")
    
    XCTAssertEqual(cachedString, string)
  }
  
  func testSet() {
    let cachedSet: Set<String>? = SKCache.shared.get(forKey: "set")
    
    XCTAssertEqual(cachedSet, set)
  }
  
  func testDictionary() {
    
    let cachedDictionary: [String : String]? = SKCache.shared.get(forKey: "dictionary")
    
    if let _cachedDictionary = cachedDictionary {
      XCTAssertEqual(_cachedDictionary, dictionaty)
    }
  }
  
  func testURL() {
    let cachedURL: URL? = SKCache.shared.get(forKey: "url")
    
    XCTAssertEqual(cachedURL, url)
  }
  
  func testImage() {
    let cachedImage: UIImage? = SKCache.shared.get(forKey: "image")
    
    XCTAssertEqual(cachedImage, image)
  }
  
  /// Test case to test the never property
  func testNever() {
    let date = Date.distantFuture
    let expiry = ExpiryDate.never
    
    XCTAssertEqual(expiry.date, date)
  }
  
  /// Test case to test the seconds property
  func testSeconds() {
    let date = Date().addingTimeInterval(1000)
    let expiry = ExpiryDate.seconds(1000)
    
    XCTAssertEqual(
      expiry.date.timeIntervalSinceReferenceDate,
      date.timeIntervalSinceReferenceDate,
      accuracy: 0.1
    )
  }
  
  /// Test case to test a date property (in this case everyDay)
  func testDate() {
    let startOfDay = Calendar.current.startOfDay(for: Date())
    var components = DateComponents()
    components.day = 1
    components.second = -1
    
    let date = Calendar.current.date(byAdding: components, to: startOfDay) ?? Date()
    let expiry = ExpiryDate.everyDay
    
    XCTAssertEqual(expiry.date, date)
  }
    
}
