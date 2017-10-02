//
//  ViewController.swift
//  Tutorial
//
//  Created by Wen on 21.09.17.
//  Copyright © 2017 WhenWens. All rights reserved.
//

import UIKit
import AlpsSDK

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a User
        appDelegate.alps.createUser("Alice", completion: {(_ user) in
            if let u = user {
                print(u.id)
                // Create a MobileDevice
                self.appDelegate.alps.createMobileDevice(name: "Alice's mobile device", platform: "iOS 9.0", deviceToken: "personnalUUID", latitude: 0.0, longitude: 0.0, altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, completion: {
                    (_ mobileDevice) in
                    if let md = mobileDevice{
                        print(md.id)
                        // Create a publication
                        let properties = ["mood": "happy"]
                        self.appDelegate.alps.createPublication(topic: "tutorial", range: 1000, duration: 300, properties: properties, completion: {
                            (_ publication) in
                            if let p = publication {
                                print(p.id)
                            }
                        })
                        
                        // Create a subscription
                        let selector = "mood = 'happy'"
                        self.appDelegate.alps.createSubscription(topic: "tutorial", selector: selector, range: 1000, duration: 300, completion: {
                            (_ subscription) in
                            if let s = subscription {
                                print(s.id)
                            }
                        })
                        
                        // Get the matches
                        self.appDelegate.alps.startUpdatingLocation()
                        self.appDelegate.alps.startMonitoringMatches()
                        // onMatch function is called everytime a match occurs.
                        self.appDelegate.alps.onMatch(completion: {
                            (_ match) in
                            print("-------------- ON MATCH ----------------")
                            print(match.id)
                        })
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

