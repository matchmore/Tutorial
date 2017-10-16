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
                print("------- USER ID --------")
                print(u.id)
                // Create a MobileDevice
                self.appDelegate.alps.createMobileDevice(name: "Alice's mobile device", platform: "iOS 9.0", deviceToken: "personnalUUID", latitude: 0.0, longitude: 0.0, altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, completion: {
                    (_ mobileDevice) in
                    if let md = mobileDevice{
                        print("------- MOBILE DEVICE ID --------")
                        print(md.id)
                        // Create a publication
                        let properties = ["mood": "happy"]
                        let topic = "tutorial"
                        let range = 1000.0
                        let duration = 300.0
                        
                        self.appDelegate.alps.createPublication(topic: topic, range: range, duration: duration, properties: properties, completion: {
                            (_ publication) in
                            if let p = publication {
                                print("------- PUBLICATION ID --------")
                                print(p.id)
                            }
                        })
                        
                        // Create a subscription
                        let selector = "mood = 'happy'"
                        self.appDelegate.alps.createSubscription(topic: topic, selector: selector, range: range, duration: duration, completion: {
                            (_ subscription) in
                            if let s = subscription {
                                print("------- SUBSCRIPTION ID --------")
                                print(s.id)
                            }
                        })
                        
                        // Get the matches
                        self.appDelegate.alps.startUpdatingLocation()
                        self.appDelegate.alps.startMonitoringMatches()
                        // onMatch function is called everytime a match occurs.
                        self.appDelegate.alps.onMatch(completion: {
                            (_ match) in
                            print("------- ON MATCH --------")
                            print(match.id)
                            print("MATCHING : Publication id : ")
                            print(match.publication?.id)
                            print("with : Subscription id : ")
                            print(match.subscription?.id)
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

