//
//  AppDelegate.swift
//  ZoomMeetingDemo
//
//  Created by Valerian on 10/03/2022.
//

import UIKit
import MobileRTC

@main
class AppDelegate: UIResponder, UIApplicationDelegate {    
    // Obtain your SDK Key and SDK Secret and paste it here.
    // Your SDK Secret should never be publicly accessible, only use the sdk key and secret for testing this demo app.
    // For a production level application, you must generate a JWT using SDK Key and Secret securely instead of using the SDK Key and SDK Secret directly on the client.
    let sdkKey = "vCN4eqidy9LrmX880pIrghaKTp7harhQ4WKb"
    let sdkSecret = "HagbAzoLKxXYIxA6zm1Xko5swXKOtEXpLjeS"
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)
        return true
    }
    
    // Logs the user out of the app upon application termination.
    // This is not a necessary action. In real use cases, the SDK should be alerted of app events. For example, in applicationWillTerminate(_ application: UIApplication), MobileRTC.shared().appWillTerminate should be called.
    func applicationWillTerminate(_ application: UIApplication) {
        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
        if let authorizationService = MobileRTC.shared().getAuthService() {
            // Call logoutRTC() to log the user out.
            authorizationService.logoutRTC()
            // Notify MobileRTC of appWillTerminate call.
            MobileRTC.shared().appWillTerminate()
        }
    }
     
    func applicationWillResignActive(_ application: UIApplication) {
        // Notify MobileRTC of appWillResignActive call.
        MobileRTC.shared().appWillResignActive()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Notify MobileRTC of appDidBecomeActive call.
        MobileRTC.shared().appDidBecomeActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Notify MobileRTC of appDidEnterBackgroud call.
        MobileRTC.shared().appDidEnterBackgroud()
    }
    
    /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.
    /// - Parameters:
    ///   - sdkKey: A valid SDK Client Key provided by the Zoom Marketplace.
    ///   - sdkSecret: A valid SDK Client Secret provided by the Zoom Marketplace.
    func setupSDK(sdkKey: String, sdkSecret: String) {
        // Create a MobileRTCSDKInitContext. This class contains attributes for determining how the SDK will be used. You must supply the context with a domain.
        let context = MobileRTCSDKInitContext()
        // The domain we will use is zoom.us
        context.domain = "zoom.us"
        // Turns on SDK logging. This is optional.
        context.enableLog = true
        // Call initialize(_ context: MobileRTCSDKInitContext) to create an instance of the Zoom SDK. Without initialization, the SDK will not be operational. This call will return true if the SDK was initialized successfully.
        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)
        // Check if initialization was successful. Obtain a MobileRTCAuthService, this is for supplying credentials to the SDK for authorization.
        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
            // Supply the SDK with SDK Key and SDK Secret.
            // To use a JWT instead, replace these lines with authorizationService.jwtToken = yourJWTToken.
            authorizationService.clientKey = sdkKey
            authorizationService.clientSecret = sdkSecret
            // Assign AppDelegate to be a MobileRTCAuthDelegate to listen for authorization callbacks.
            authorizationService.delegate = self
            // Call sdkAuth to perform authorization.
            authorizationService.sdkAuth()
        }
    }
}


extension AppDelegate : MobileRTCAuthDelegate {
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case MobileRTCAuthError.success :
            print("SDK successfully initialized.")
        case MobileRTCAuthError.keyOrSecretEmpty:
            assertionFailure("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case MobileRTCAuthError.keyOrSecretWrong, MobileRTCAuthError.unknown:
            assertionFailure("SDK Key/Secret is not valid.")
        default:
            assertionFailure("SDK Authorization failed with MobileRTCAuthError: (returnValue).")
        }
    }
}
