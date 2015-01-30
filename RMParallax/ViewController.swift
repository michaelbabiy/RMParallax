//
//  ViewController.swift
//  RMParallax
//
//  Created by Michael Babiy on 1/25/15.
//  Copyright (c) 2015 Raphael Miller & Michael Babiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = RMParallaxItem(image: UIImage(named: "item1")!, text: "SHARE LIGHTBOXES WITH YOUR TEAM")
        let item2 = RMParallaxItem(image: UIImage(named: "item2")!, text: "FOLLOW WORLD CLASS PHOTOGRAPHERS")
        let item3 = RMParallaxItem(image: UIImage(named: "item3")!, text: "EXPLORE OUR COLLECTION BY CATEGORY")
        
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: false)
        rmParallaxViewController.completionHandler = {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

