# Tutorial Alps iOS SDK

Welcome ! In this tutorial, we will demonstrate how to start using our `Advanced Location Publish Subscribe(ALPS) SDK` in the iOS environnement.

## What we will go through

1. Install `ALPS` and `ALPS SDK` in the Xcode project via CocoaPods

2. Use the `ALPS SDK`
* Create a `user`
* Create a `mobile device`
* Create a `publication`
* Create a `subscription`
* Get the `matches`

### Install ALPS and ALPS SDK in the Xcode project via CocoaPods

We assume that you already have CocoaPods installed on your laptop. If not, please refer to this link [https://cocoapods.org/](https://cocoapods.org/) and install it.

* Use cd command in the terminal to open the Xcode project repository in which you want to use `ALPS SDK`.

      cd /Users/userAccount/Desktop/Tutorial

**Note** : In this tutorial, the project is in the Desktop and the folder name is “Tutorial”.
In the terminal, you should be located in the repository of your project.

* You can now enter this command that will initiate a pod.

      pod init

Check that it was correctly initiated by opening your repository.

* Open the recently created Podfile with a text editor.

Copy-paste the following lines into your podfile under `# Pods for your_project_name` and save the file.

```
pod 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git', :tag => ‘0.4.0'
pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git', :tag => ‘0.4.2'
```

 See image below for an example.

![alt text](https://github.com/matchmore/Tutorial/blob/master/readmeImage/pod.png "pod copy-paste")

* Go back to your terminal and make sure you are in your project repository.

* Then, enter the following command to install `ALPS SDK` and `ALPS` in your project :

      pod install

* Open the workspace.

![alt text](https://github.com/matchmore/Tutorial/blob/master/readmeImage/workspace.png "workspace")

* Check that the pods are correctly installed.


![alt text](https://github.com/matchmore/Tutorial/blob/master/readmeImage/installedPod.png "pod installed")

We are ready to use `ALPS SDK`.

## Use the ALPS SDK

### Setting up the SDK
Before setting up Alps SDK, we need to add `Privacy - Location Always Usage Description` in `info.plist` file to allow the use of Core Location kit in the project. Add a description `"Need location usage for Alps SDK"`. See image below.
![alt text](https://github.com/matchmore/Tutorial/blob/master/readmeImage/info-plist.png "info-plist")

All the functions you need are grouped in the AlpsManager class.

It would be good to have a look at our SDK, the protocol AlpsSDK regroups all the functions that are implemented in the AlpsManager class.

### Initiate an AlpsManager

We advice you to initiate the **AlpsManager** in your `appDelegate`, which will allow you to refer it in all your application.

**Keep in mind, that you should have only one AlpsManager for the whole project.**

Go in the file `AppDelegate`, add `import AlpsSDK`.

Then initiate a variable with name `alps` of class **AlpsManager**.
You also need your api-key for your AlpsManager. To get the api-key, please follow the “step-by-step” instructions.

Once you have the api-key, declare a constant with name `APIKEY` and value of your api-key.

ALPS SDK is built upon the CoreLocation package, if you want to have a reference to your CLLocationManager, you will need to initiate it by yourself. The following instruction will explain you how to have your own reference to the CLLocationManager, you can skip it if you don’t want to use Core Location package. When skipping this step, AlpsManager will initiate his own CLLocationManager.

Import CoreLocation in your AppDelegate. Then initiate a variable with name `locationManager` of class **CLLocationManager**.
In the function `didFinishLaunchingWithOptions`, write the following code :

```swift
locationManager = CLLocationManager.init()
alps = AlpsManager.init(apiKey: APIKEY, clLocationManager: locationManager)
```

You can now refer to the alps variable in your AppDelegate to use our ALPS SDK.

Find below what your AppDelegate should look like after the settings.

### Create a user

First, go to your file `ViewController`.

Add this line in class ViewController, to get a reference to the application's delegate :

      let appDelegate = UIApplication.shared.delegate as! AppDelegate

Inside of function `ViewDidLoad()`
* Use the constant appDelegate to get a reference to **AlpsManager**.
* Call the function `createUser(username: String, completion : (User?) -> Void)`. Fill the required parameters and you can use the completion to get the returned `User` object created in our cloud service.
* Use the completion to get the user and print his id.

Hint : Each object in our model has his own **Universal Unique Identifier(UUID)**.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.alps.createUser("Alice", completion: {(_ user) in
                   if let u = user {
                       print(u.id)
                     }
                     })

// ...
}
```

When you create a user, our SDK automatically store it in an array but only the very first user created is designated to be the **AlpsUser**.

### Create a mobile device

**Inside the completion of createUser() function**, write the following lines.

We want to make sure the user is created before we call the device creation.

* Use the constant appDelegate to get the AlpsManager.
* Call the function `createMobileDevice(name: String, platform: String, deviceToken: String, latitude: Double, longitude: Double, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, completion: (MobileDevice?) -> Void)`. You can just fill the parameters that asks for `Double` with a 0.0, we will show you how to update position later.
* Use the completion to get the mobile device and print his id.

As it is for the AlpsUser, same goes for AlpsDevice. The first mobile device that you create will be designated to be the AlpsDevice.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.alps.createUser("Alice", completion: {(_ user) in
                   if let u = user {

        // ...
                  // inside of createUser() completion
                  self.appDelegate.alps.createMobileDevice(name: "Alice's mobile device", platform: "iOS 9.0", deviceToken: "738a5b9c-61c3-4cf7-937d-20fe9b1ae69c", latitude: 0.0, longitude: 0.0, altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, completion: {
                                      (_ mobileDevice) in
                                      if let md = mobileDevice{
                                          print(md.id)
                                        }
                                      })
        // ...
                    }
        })
}

```

### Create a publication

In our SDK, there is two createPublication() function available. One uses the AlpsUser and AlpsDevice as the target to create the publication. The other one, you have the option to set for which user and which device you would like to create this publication by providing UUID.

**Inside the completion of createMobileDevice() function**, write the following lines.


* Use the constant appDelegate to get the AlpsManager.
* Call the function `createPublication(topic : String, range: Double, duration: Double, properties: [String:String], completion: (_ publication?) -> Void)`.

We are based on the publish/subscribe model, you need to match the topic of publisher and subscriber.
We have also added finer filters by using properties and selector.

Use these parameters for the rest of the tutorial

```swift
let properties = ["mood": "happy"]
let topic = "tutorial"
let range = 1000.0
let duration = 300.0
```

* Use the completion to get the publication and print his id.

```swift

// ...
// these lines are inside of createMobileDevice() completion
// Create a publication
                        let properties = ["mood": "happy"]
                        let topic = "tutorial"
                        let range = 1000.0
                        let duration = 300.0
                        self.appDelegate.alps.createPublication(topic: topic, range: range, duration: duration, properties: properties, completion: {
                                                    (_ publication) in
                                                    if let p = publication {
                                                        print(p.id)
                                                    }
                                                })
// ...
```

### Create a subscription

As for the publication, you can create subscription for your main device or for other devices by providing UUID.

**Inside the completion of createMobileDevice() function**, write the following lines.

* Use the constant appDelegate to get the AlpsManager.
* Call the function `createSubscription(topic: String, selector: String, range: Double, duration: Double, completion: (_ subscription?) -> Void)`. Fill the function with the same parameters as for publication.

We will use selector to add one more filter.

```swift
let selector = "mood = 'happy'"
```

* Use the completion to get the subscription and print his id.

```swift
// ...
// these lines are inside of createMobileDevice() completion
// Create a subscription
                        let selector = "mood = 'happy'"
                        self.appDelegate.alps.createSubscription(topic: topic, selector: selector, range: range, duration: duration, completion: {
                            (_ subscription) in
                            if let s = subscription {
                                print(s.id)
                            }
                        })
// ...
```

### Get the matches

**Inside the completion of createMobileDevice() function**, write the following lines.

* Use the constant appDelegate to get the AlpsManager.
* Call the function `startUpdatingLocation()`, to update location to our cloud service.
* Call the function `startMonitoringMatches()`, to start matches monitoring.
* Use the function `onMatch()` and the completion to get the match and print his id.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
// ...
// These lines are inside of the completion of createMobileDevice() function
// Start updating location of mobile device
                        self.appDelegate.alps.startUpdatingLocation()
// Get the matches
                        self.appDelegate.alps.startMonitoringMatches()
                        // onMatch function is called every time a match occurs.
                        self.appDelegate.alps.onMatch(completion: {
                            (_ match) in
                            print("-------------- ON MATCH ----------------")
                            print(match.id)
                        })
// ...
```

At the end of this section, ViewController should be looking like this :

```swift
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
                        let topic = "tutorial"
                        let range = 1000.0
                        let duration = 300.0

                        self.appDelegate.alps.createPublication(topic: topic, range: range, duration: duration, properties: properties, completion: {
                            (_ publication) in
                            if let p = publication {
                                print(p.id)
                            }
                        })

                        // Create a subscription
                        let selector = "mood = 'happy'"
                        self.appDelegate.alps.createSubscription(topic: topic, selector: selector, range: range, duration: duration, completion: {
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
```

## Run Tutorial

Run `Tutorial` and see how our `Alps SDK` Works.

You should be able to see in the log, the printed iDs and that a match was found on our core service.

![alt text](https://github.com/matchmore/Tutorial/blob/master/readmeImage/result.png "result")

Thank you for following this tutorial.

Don't hesitate to contact us for further informations.

## Documentation

See the [http://dev.matchmore.com/documentation/api](http://dev.matchmore.com/documentation/api) or consult our website for further information [http://dev.matchmore.com/](http://dev.matchmore.com/)

## Author

rk, rafal.kowalski@mac.com

jdu, jean-marc.du@matchmore.com
