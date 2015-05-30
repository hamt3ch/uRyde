//
//  AppDelegate.swift
//  uRyde
//
//  Created by Hugh A. Miles on 5/15/15.
//  Copyright (c) 2015 ph7. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate, MFMessageComposeViewControllerDelegate {

    var window: UIWindow?
    var client: SINClient?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("XtZNXXbzP5R99gWlwRM6ZiRjXxrRoKRd8UEy5QoU",
            clientKey: "0HGWsTpKKC3f8KGGtDWES2hQ25PRGYiMfiBJYpGq")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
       
        //Setup PushNotes
        intializeCustomPushNotes(application)
        
        let tabBarCtrl = UITabBarController()
        tabBarCtrl.selectedIndex = 1
        
        
        return true
    }
    
    //SinchIM - Delegate
    func createSinchClient(userId: String) {
        if client == nil {
            client = Sinch.clientWithApplicationKey("728f3ab4-a1d6-45d6-9db8-01a9003fb82e", applicationSecret: "4H4nXopLk0aMHqAmicusiA==", environmentHost: "sandbox.sinch.com", userId: userId)
            
            client!.setSupportCalling(true)
            client!.setSupportActiveConnectionInBackground(true)
            
            client!.delegate = self
            
            client!.start()
            client!.startListeningOnActiveConnection()
        }
    }
    
    func clientDidStart(client: SINClient) {
        NSLog("client did start")
    }
    
    func clientDidStop(client: SINClient) {
        NSLog("client did stop")
    }
    
    func clientDidFail(client: SINClient, error: NSError!) {
        NSLog("client did fail", error.description)
        let toast = UIAlertView(title: "Failed to start", message: error.description, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
    }
    
    
    //PushNotes - Delegate
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error.localizedDescription)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        
    }
 
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func intializeCustomPushNotes(application:UIApplication)
    {
        var acceptAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        acceptAction.title = "Accept"
        acceptAction.identifier = "ACCEPT"
        acceptAction.activationMode = UIUserNotificationActivationMode.Background
        acceptAction.authenticationRequired = false
        
        var declineAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        declineAction.title = "Decline"
        declineAction.identifier = "DECLINE"
        declineAction.activationMode = UIUserNotificationActivationMode.Background
        declineAction.authenticationRequired = false
        
        //Category
        var myCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        myCategory.identifier = "MY_CATEGORY"
        
        let myActions:NSArray = [acceptAction,declineAction]
        myCategory.setActions(myActions as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        let categories:NSSet = NSSet(objects:myCategory)
        
        //ParsePushNotifications
        let notificationTypes:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        

    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        completionHandler()
        
        println(userInfo)
        
        if(identifier == "ACCEPT")
        {
            println("Accept notification pressed")
            
//            println(MFMessageComposeViewController.canSendText())
//            //launchMessageComposeViewController()
//                // send text message to requestingUser
//            let vc = UIViewController()
//            self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
        }
        
        else
        {
            println("Decline notification pressed")
                // send push notification to declineUser
        }
        
         completionHandler()
        
    }
    
    
    //MessageUI - Delegate
  
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
      //  self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func canSendText() -> Bool {
        
        return MFMessageComposeViewController.canSendText()
        
    }
    
    
    
    // Configures and returns a MFMessageComposeViewController instance
    
    func configuredMessageComposeViewController(textMessageRecipients:[String] ,textBody body:String) -> MFMessageComposeViewController {
        
        let messageComposeVC = MFMessageComposeViewController()
        
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        
        messageComposeVC.recipients = textMessageRecipients
        
        messageComposeVC.body = body
        
        return messageComposeVC
        
    }

    
}

