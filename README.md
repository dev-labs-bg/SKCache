![skcache-logo](https://github.com/dev-labs-bg/SKCache/blob/master/Example/SKCache/Supporting%20Files/Resources/skcache-logo.png)

## Table of Contents

* [Description](#description)
* [Key features](#key-features)
* [Usage](#usage)
* [Storage](#storage)
* [Configuration](#configuration)
* [Expiry date](#expiry-date)
* [Adding/Fetching objects](#add-fetch-object)
* [Enable disk storage](#disk-storage)
* [Installation](#installation)
* [Author](#author)
* [Contributing](#contributing)
* [License](#license)


## Description

**SKCache** doesn't claim to be unique in this area, but it's not another monster
library that gives you a god's power. It does nothing but caching, but it does it well.

## Key features

- [x] Work with Swift 4 and Swift 3.2.
- [x] Disk storage is optional.
- [x] Support `expiry` and clean up of expired objects.
- [x] Extensive unit test coverage
- [x] iOS, tvOS support.

## Usage

### Storage

`SKCache` is built based on `NSCache` and supports all valid types in Swift. It has memory storage and can support optionaly disk storage. Memory storage should be less time and memory consuming, while disk storage is used for content that outlives the application life-cycle, see it more like a convenient way to store user information that should persist across application launches.


#### Codable types

`SKCache` supports any objects that conform to [Codable](https://developer.apple.com/documentation/swift/codable) protocol. You can [make your own things conform to Codable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) so that can be saved and loaded from `SKCache`.

The supported types are

- Primitives like `Int`, `Float`, `String`, `Bool`, ...
- Array of primitives like `[Int]`, `[Float]`, `[Double]`, ...
- Set of primitives like `Set<String>`, `Set<Int>`, ...
- Simply dictionary like `[String: Int]`, `[String: String]`, ...
- `Date`
- `URL`
- `Data`

#### Error handling

Error handling is done via `try catch`. `SKCache` throws errors in terms of `Operations`.

```swift
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
```

There can be errors because of disk problem or type mismatch when saving/loading into/from device storage, so if want to handle errors, you need to do `try catch`

```swift
do {
try SKCache.save()
} catch {
print(error)
}
```

```swift
do {
try SKCache.load()
} catch {
print(error)
}
```

### Configuration

Here is how you can setup some configuration options

```swift
SKCache.elementsCount = 1000 // setup total count of elements saved into the cache

SKCache.elementsCostLimit = 1024 * 1024 // setup the cost limit of the cache

SKCache.shared.expiration = .everyDay // setup expiration date of each object in the cache
```

### Expiry date

By default, all saved objects have the same expiry as the expiry you specify in `SKCache.shared.expiration` . You can overwrite this for a specific object by specifying `expiry` in the constructor of `SKObject`

```swift
// Default expiry date from configuration will be applied to the item
let object = SKObject(value: "This is a string", key: "string")

// A given expiry date will be applied to the item
let object = SKObject(value: "This is a string", key: "string", expirationDate: ExpiryDate.everyDay.expiryDate())
```

### <a name="add-fetch-object"></a> Adding/Fetching objects

If you want to add or fetch an object you just follow thise simple steps:

```swift
//1. Create a SKObject
let object = SKObject(value: "This is a string", key: "string")

//2. Add it to the cache
SKCache.shared.add(object: object)

//3. Fetch an object from the cache
let string: String? = SKCache.shared.get(forKey: "string")
```

### <a name="disk-storage"></a> Enable disk storage

As mentioned `SKCache` supports optionally disk storage. All objects will be stored in the Cache directory of the device. To enable disk storage simply add `SKCache.load()` in the `application(, didFinishLaunchingWithOptions:)` in `AppDelegate.swift`:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

.
.
.

do {
try SKCache.load()
} catch {
print(error)
}

return true
}
```
But that only will try to load the cache with objects. To fully utilize the disk storage `SKCache.save()` must be added in the `applicationDidEnterBackground(_)`:

```swift
func applicationDidEnterBackground(_ application: UIApplication) {

.
.
.

do {
try SKCache.save()
} catch {
print(error)
}
}
```

## Installation

### Cocoapods

**SKCache** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SKCache'
```

## Author

`SKCache` was created and is maintaned by Dev Labs. You can find us [@devlabsbg](https://twitter.com/devlabsbg) or [devlabs.bg](http://devlabs.bg/)

## Contributing

We would love you to contribute to **SKCache**, so:
- if you found a bug, open an issue
- if you have a feature request, open an issue
- if you want to contribute, submit a pull request

## License

**SKCache** is available under the MIT license. See the [LICENSE](https://github.com/dev-labs-bg/SKCache/blob/master/LICENSE.md)
