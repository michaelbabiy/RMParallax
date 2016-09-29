# RMParallax

[![Build Status](https://travis-ci.org/michaelbabiy/RMParallax.svg?branch=api)](https://travis-ci.org/michaelbabiy/RMParallax)
[![Swift 3](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Twitter](https://img.shields.io/badge/Twitter-@michaelbabiy-blue.svg?style=flat)](http://twitter.com/michaelbabiy)

RMParallax is a library designed to help you introduce the features of your app on the first app launch. See it in [action](https://www.youtube.com/watch?v=5QRMohq1nBE).

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

- [X] Add **RMParallax** folder containing ```RMController.swift```, ```RMItem.swift```, ```RMStyle.swift``` to your project
- [X] There is no step two

## Usage

RMParallax is simple to use. All you have to do is create RMItem:

```swift
let item1 = RMItem(image: UIImage(named: "item1")!, text: "SHARE LIGHTBOXES WITH YOUR TEAM")
let item2 = RMItem(image: UIImage(named: "item2")!, text: "FOLLOW WORLD CLASS PHOTOGRAPHERS")
let item3 = RMItem(image: UIImage(named: "item3")!, text: "EXPLORE OUR COLLECTION BY CATEGORY")
let items = [item1, item2, item3]
```

Create RMParallax controller with items you created earlier:

```swift
let introducing = RMController(with: items)
introducing.dismiss = {
	introducing.view.removeFromSuperview()
	introducing.removeFromParentViewController()
}
```

Add your RMParallax controller to the view controller:

```swift
addChildViewController(introducing)
view.addSubview(introducing.view)
introducing.didMove(toParentViewController: self)
```

> RMParallax uses closures to notify presenting view controller when the user is done paging through.

Please checkout included sample project.

## Creators
* [Michael Babiy](http://twitter.com/michael.babiy)
* Raphael Miller