# shieldcredit-spm

shieldcredit-spm is the ShieldFraud Swift Package Manager (www.shield.com)

ShieldCredit helps developers to assess malicious activities performed on mobile devices and return risk intelligence based on user's behaviour. It collects device's fingerprint, social metrics and network information. 

There are four steps to getting started with the SHIELD SDK:

1. [Integrate the SDK](#integrate-the-sdk)

2. [Initialize the SDK](#initialize-the-sdk)

3. [Get Session ID](#get-session-id)

4. [Get Device Results](#get-device-results)

5. [Send Custom Attributes](#send-custom-attributes)


### Integrate the SDK

SHIELD SDK is compatible with apps supporting iOS 12 and above using Swift Package Manager. It is built with Swift. You can install this by using below format


**SPM:**
```
.package(url: "https://github.com/shield-ai-technology/shieldcredit-spm.git", from: "1.5.27"),
```

**XCODE**
```
File -> Add Package -> https://github.com/shield-ai-technology/shieldcredit-spm.git (Point to master branch)
```
**Note**: We make continuous enhancements to our fraud library and detection capabilities which includes new functionalities, bug fixes and security updates. We recommend updating to the latest SDK version to protect against rapidly evolving fraud risks.

You can refer to the Changelog to see more details about our updates.

### Initialize the SDK

The SDK initialization should be configured `didFinishLaunchingWithOptions` in your `AppDelegate` subclass to ensure successful generation and processing of the device fingerprint. SDK is to be initialised only once and will throw an exception if it is initialised more than once.

You need both the `SHIELD_SITE_ID` and `SHIELD_SECRET_KEY` to initialize the SDK. You can locate them at the top of the page.

For **Objective-C**
```
@import ShieldCredit;
...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
  Configuration *config = [[Configuration alloc] initWithSiteId:@"SHIELD_SITE_ID" secretKey:@"SHIELD_SECRET_KEY"];
  [Shield setUpWith:config];
  return YES;
}
```
For **Swift**
```
import ShieldCredit
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let config = Configuration(withSiteId: "SHIELD_SITE_ID", secretKey:"SHIELD_SECRET_KEY")
    Shield.setUp(with: config)
    return true
}
```
Configuration class has these optional parameters:
1. **deviceShieldCallback** 
        *Purpose:* Registers callback to listen to changes to device result in the background.    
        *Description:* Receives device result when the SDK receives updated results from the server.
2. **logLevel**    
        *Purpose:* Sets your log level to `debug`, `info` or `none`.    
        *Description:* Receives high-level information about how the SDK processes network requests, responses or error information during SDK integration. `Default` log level is `none`
3. **enableMocking**
        *Purpose:* Sends mock JSON response for DeviceShieldCallback.    
        *Description:* Sets this to `true` to receive the expected JSON response during testing. Default setting is `false`. Remove this flag for `production` to get the actual response.


### Get Session ID
Session ID is the unique identifier of a user’s app session and acts as a point of reference when retrieving the device result for that session.


Session ID follows the OS lifecycle management, in-line with industry best practice. This means that a user’s session is active for as long as the device maintains it, unless the user terminates the app or the device runs out of memory and has to kill the app.

If you would like to retrieve device results using the backend API, it is important that you store the Session ID on your system. You will need to call the SHIELD backend API using this Session ID.

To retrieve the Session ID, call:

For **Objective-C**
```
NSString *sessionId = [[Shield shared]sessionId];
```
For **Swift**
```
let sessionId = Shield.shared().sessionId
```

### Get Device Results
SHIELD provides you actionable device intelligence which you can retrieve from the SDK, via the Optimized Listener or Customized Pull method.
Alternatively you can also retrieve results via the backend API.

`Warning: To avoid crashes and unexpected behavior, apps should only use the officialy documented parts of the methods and classes in the SDK.`

*Only 1 method of obtaining device results **(Optimized Listener or Customized Pull)** can be in effect at any point in time.*

#### Retrieve device results via Optimized Listener

##### SHIELD recommends the Optimized Listener method to reduce number of API calls. #####

Our SDK will capture an initial device fingerprint upon SDK initialization and return an additional set of device intelligence ONLY if the device fingerprint changes along one session. This ensures a truly optimized end to end protection of your ecosystem.

You can register a callback if you would like to be notified in the event that the device attributes change during the session (for example, a user activates a malicious tool a moment after launching the page).

Add an additional parameter during intialization in order to register a callback. 

For **Objective-C**
```
@import ShieldCredit;
...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
  Configuration *config = [[Configuration alloc] initWithSiteId:@"SHIELD_SITE_ID" secretKey:@"SHIELD_SECRET_KEY"];
  config.deviceShieldCallback = [[ShieldCallback alloc] init]; // callback for to get updated result real time
  [Shield setUpWith:config];
  return YES;
}

...
@import ShieldCredit;

@interface ShieldCallback : NSObject<DeviceShieldCallback>
@end

@implementation ShieldCallback
- (void)didErrorWithError:(NSError *)error
{
  //Something went wrong, log the exception
}
- (void)didSuccessWithResult:(NSDictionary<NSString *,id> *)result
{
    //do something with device result
}
@end
```

For **Swift**
```
import ShieldCredit
...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let config = Configuration(withSiteId: "SHIELD_SITE_ID", secretKey:"SHIELD_SECRET_KEY")
    config.deviceShieldCallback = ShieldCallback()  // callback for to get updated result real time
    Shield.setUp(with: config)
    return true
}

...
class ShieldCallback: DeviceShieldCallback {

    func didError(error: NSError) {
      //Something went wrong, log the exception
    }

    func didSuccess(result: [String: Any]) {
      //do something with device result
    }
}
```

Click here for a sample of the device result response.

#### Retrieve device results via Customized Pull
You can retrieve device results at specific user checkpoints or activities, such as account registration, login, or checkout. This is to ensure that there is adequate time to generate a device fingerprint.

To retrieve the device result via Customized Pull, call:

For **Objective-C**
```
[[Shield shared] setDeviceResultStateListener:^{ // check whether device result assessment is complete
    NSDictionary<NSString *, id> *result = [[Shield shared] getLatestDeviceResult];
    if (result != NULL) {
      //do something with the result
    }

    NSError *error = [[Shield shared] getErrorResponse];
    if (error != NULL) {
      // log error
    }
}];
```

For **Swift**
```
Shield.shared().setDeviceResultStateListener {  // check whether device result assessment is complete
    if let deviceResult = Shield.shared().getLatestDeviceResult() {
        //do something with the result
    }

    if let error = Shield.shared().getErrorResponse() {
        // log error
    }
}
```
`setDeviceResultStateListener(isDeviceStateReady: (() -> Void)?)` checks whether DeviceResult is ready to be retrieved. `getLatestDeviceResult()` retrieves the latest DeviceResult. It is possible that this returns null in the event that this function is called before assessment is completed. `getErrorResponse()` enables troubleshooting for unsuccessful DeviceResult retrievals.

Click here for a sample of the device result response.

`Warning: Only 1 method of obtaining device results (Optimized Listener or Customized Pull) can be in effect at any point in time.`

It is possible that getLatestDeviceResult returns null if the device result retrieval is unsuccessful. 

### Send Custom Attributes

Use the sendAttributes function to sent event-based attributes such as user_id or activity_id for enhanced analytics. This function accepts two parameters:screenName where the function is triggered, and data to provide any custom fields in key, value pairs.

#### Send custom attributes with callback
You can register a callback if you would like to be notified when SHIELD has successfully received the custom attributes.

For **Objective-C**
```
@import ShieldCredit;
...
- (void) sendAttributes
{
      NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: 
                          @"value_1",@"key_1",  // add keys and values as described in custom attributes table in the Dictionary
                          @"value_2",@"key_2", 
                          nil];
    [[Shield shared] setDeviceResultStateListener:^{ // check whether device fingerprinting is completed
        [[Shield shared] sendAttributesWithScreenName:@"Login" data: attributes :^(BOOL status, NSError * error) {
            if (error != nil) {
                NSLog(@"%@", error.description);
            } else {
                NSLog(@"%@", status ? @"true" : @"false");
                // true if collection is successful, false if something with insertion to database
            }
        }];
    }];
}
```

For **Swift**

```
import ShieldCredit
...
func sendAttributes() {
    let attributes = ["key_1": "value_1", // add keys and values as described in custom attributes table in the Dictionary
                      "key_2": "value_2"]
    Shield.shared().setDeviceResultStateListener { // check whether device fingerprinting is completed
        Shield.shared().sendAttributes(withScreenName: "login", data: attributes) { (status, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(status)
            }
        }
    }
}
```

#### Send custom attributes without callback
The task will run in the background thread without callback.

For **Objective-C**
```
@import ShieldCredit;
...
- (void) sendAttributes

{
      NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: 
                          @"value_1",@"key_1",  // add keys and values as described in custom attributes table in the Dictionary
                          @"value_2",@"key_2", 
                          nil];
    [[Shield shared] setDeviceResultStateListener:^{ // check whether device fingerprinting is completed
        [[Shield shared] sendAttributesWithScreenName:@"Login", data: attributes]];
    }];
}
```

For **Swift**
```
import ShieldCredit
...
func sendAttributes() {
    let attributes = ["key_1": "value_1", // add keys and values as described in custom attributes table in the Dictionary
                      "key_2": "value_2"]
    Shield.shared().setDeviceResultStateListener { // check whether device fingerprinting is completed
        Shield.shared().sendAttributes(withScreenName: "Login", data: attributes)
    }
}
```
