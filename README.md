# AWSLocations
This is Swift Library for Locations.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like `AWSPlacePicker` in your projects. 

First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'AWSLocations'
```

Second, install `AWSLocations` into your project:

```ruby
pod install
```

## Important
Please make sure you have added location privacy keys in info plist that is 

```ruby
<key>NSLocationUsageDescription</key>
<string></string>
<key>NSLocationWhenInUseUsageDescription</key>
<string></string>
```


## Usage

Import Library into View Controller Where you want to use utilities

```ruby
import AWSLocations
```

Than start using

```ruby
AWSLocationsUtils.shared.trackLocationChanges { (loc) in
  print(loc)
}
```

You can customize settings

```ruby
// Please make sure this need to be set in AppDelegate !Before accessing AWSLocationsUtils.shared object
AWSLocationsUtils.distanceFilter = 25.0
AWSLocationsUtils.alwaysRequired = true
```

## License

`AWSLocations` is distributed under the terms and conditions of the [MIT license]
