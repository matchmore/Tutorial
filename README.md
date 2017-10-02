# Tutorial Alps iOS SDK

Welcome ! In this tutorial, we will demonstrate how to start using our `Advanced Location Publish Subscribe(ALPS) SDK` in the iOS environnement.

## What we will go through

1. Install `ALPS` and `ALPS SDK` in the Xcode project via CocoaPods
2. Use the `ALPS SDK`
⋅⋅* Create a `user`
⋅⋅* Create a `mobile device`
⋅⋅* Create a `publication`
⋅⋅* Create a `subscription`
⋅⋅* Get the `matches`

### Install ALPS and ALPS SDK in the Xcode project via CocoaPods

We assume that you already have CocoaPods installed on your laptop. If not, please refer to this link [https://cocoapods.org/](https://cocoapods.org/) and install it.

Use cd command in the terminal to open the Xcode project repository in which you want to use `ALPS SDK`.

  cd /Users/userAccount/Desktop/Tutorial

**Note** : In this tutorial, the project is in the Desktop and the folder name is “Tutorial”.
In the terminal, you should be located in the repository of your project. You need to enter this command that will initiate a pod.

  pod init
  
Check that it was correctly initiated by opening your repository.

Open the recently created Podfile with a text editor. We will use Atom.

Copy-paste the following lines into your podfile under `# Pods for your_project_name`. See image below for an example.

  pod 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git', :tag => ‘0.4.0'
  pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git', :tag => ‘0.4.0'

Save your podfile and go back to your terminal.
Go back to your terminal and make sure you are in your project repository. Then, enter the following command
pod install
It will install ALPS SDK and ALPS in your project via Cocoapods.
Open the workspace.

Check that the pods are correctly installed. 
You can close the terminal. We are ready to use `ALPS SDK`.

## Use the ALPS SDK

### Setting up the SDK
Before setting up Alps SDK, we need to add “Privacy - Location Always Usage Description” in info.plist file to allow the use of Core Location kit in the project. Add a description “Need location usage for Alps SDK”. See image below.

All the functions you need are grouped in the AlpsManager class. It is good that you have a look at our SDK, the protocol AlpsSDK regroups all the functions that are implemented in the AlpsManager class.

### Initiate an AlpsManager

We advice you to initiate the AlpsManager in your appDelegate, which will allow you to refer it in all your application. Keep in mind, that you should have only one AlpsManager for the whole project.
Go in the file AppDelegate, add import AlpsSDK.
Then initiate a variable with name “alps” of class AlpsManager. You also need your api-key for your AlpsManager. To get the api-key, please follow the “step-by-step” instructions.
Once you have the api-key, declare a constant with name “APIKEY” and value of your api-key.
ALPS SDK is built upon the CoreLocation package, if you want to have a reference to your CLLocationManager, you will need to initiate it by yourself. The following instruction will explain you how to have your own reference to the CLLocationManager, you can skip it if you don’t want to use Core Location package. When skipping this step, AlpsManager will initiate his own CLLocationManager.
Import CoreLocation in your AppDelegate. Then initiate a variable with name “locationManager” of type CLLocationManager.
In the function “didFinishLaunchingWithOptions”, write the following code :
locationManager = CLLocationManager.init()
alps = AlpsManager.init(apiKey: APIKEY, clLocationManager: locationManager)
You can now refer to the alps variable in your AppDelegate to use our ALPS SDK.
Find below what your AppDelegate should look like after the settings.

### Create a user

First, go to your file ViewController. Then, get a reference to the application's delegate. Add this line in class ViewController :
let appDelegate = UIApplication.shared.delegate as! AppDelegate
Use the constant appDelegate to get the AlpsManager.
Call the function createUser(username: String, completion : (User?) -> Void). You need to define a String which will be used as a username and you can use the closure to get the returned User  object created in our cloud service.
Use the completion to get the user and print his id.
Hint : Each object in our model has his own Universal Unique Identifier(UUID).
```swift
```
When you create a user, our SDK automatically store it in an array but only the very first user created is designated to be the AlpsUser.

### Create a mobile device

Inside the completion of createUser() function, write the following lines. Because we want to make sure the user is created before we call the device creation.
Use the constant appDelegate to get the AlpsManager.
Call the function createMobileDevice(name: String, platform: String, deviceToken: String, latitude: Double, longitude: Double, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, completion: (MobileDevice?) -> Void). Fill this function with the required parameters.
Use the completion to get the mobile device and print his id.
As it is for the AlpsUser, same goes for AlpsDevice. The first mobile device that you create will be designated to be the AlpsDevice.

```swift
```

### Create a publication

Inside the completion of createMobileDevice() function, write the following lines. In our SDK, there is two createPublication() function available. One uses the AlpsUser and AlpsDevice as the target to create the publication. The other one, you can set for which user and which device you would like to create this publication by providing UUID.
Use the constant appDelegate to get the AlpsManager.
Call the function createPublication(topic : String, range: Double, duration: Double, properties: [String:String], completion: (_ publication?) -> Void). Fill the function with the required parameters.
Use the completion to get the publication and print his id.

```swift
```

### Create a subscription

Inside the completion of createMobileDevice() function, write the following lines.
As for the publication, you can create subscription for your main device or for other devices by providing UUID.
Use the constant appDelegate to get the AlpsManager.
Call the function createSubscription(topic: String, selector: String, range: Double, duration: Double, completion: (_ subscription?) -> Void). Fill the function with the required parameters.
Use the completion to get the subscription and print his id.
```swift
```

### Get the matches

Inside the completion of createMobileDevice() function, write the following lines.
Use the constant appDelegate to get the AlpsManager.
Call the function startMonitoringMatches(), which will start matches monitoring. You might also want to call the function startUpdatingLocation(), this will communicate your GPS location to our cloud service.
Use the function onMatch() and the completion to get the match and print his id.

```swift
```

Your final ViewController should look something like below.

## Example

To run the example project, clone the repo, and run \`pod install\` from
the Example directory first.

## Documentation

See the [http://dev.matchmore.com/documentation/api](http://dev.matchmore.com/documentation/api) or consult our website for further information [http://dev.matchmore.com/](http://dev.matchmore.com/)

## Author

rk, rafal.kowalski@mac.com


## License

Alps is available under the MIT license. See the LICENSE file for more info.
