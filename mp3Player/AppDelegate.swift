//
//  AppDelegate.swift
//  mp3Player
//
//  Created by Saud Al-Mutlaq on 8/14/2015.
//  Copyright (c) 2015 saudsoft.com. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem?
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        print("Application performActionForShortcutItem")
        
        completionHandler( handleShortcut(shortcutItem) )
    }
    
    func handleShortcut( _ shortcutItem:UIApplicationShortcutItem ) -> Bool {
        print("Handling shortcut")
        
        var succeeded = false
        if( shortcutItem.type == "com.saudsoft.mp3Player2.PlaySound" )
        {
            // Add your code here
            print("- Handling \(shortcutItem.type)")

            let mainViewController = self.window!.rootViewController as! ViewController

            mainViewController.shortCutPlay()
            
            succeeded = true
            
        }
        return succeeded
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var performShortcutDelegate = true
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            print("Application launched via shortcut")
            self.shortcutItem = shortcutItem
            
            performShortcutDelegate = false
        }
        
        
        return performShortcutDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Application did become active")
        
//        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
//        handleShortcut(shortcut)
        
        self.shortcutItem = nil
    }

//    override func remoteControlReceived(with event: UIEvent?) {
//        guard let event = event else {
//            print("no event\n")
//            return
//        }
//        guard event.type == UIEvent.EventType.remoteControl else {
//            print("received other event type\n")
//            return
//        }
//        switch event.subtype {
//        case UIEvent.EventSubtype.remoteControlPlay:
//            print("received remote play\n")
//            //ViewController.sharedInstance.play()
//        case UIEvent.EventSubtype.remoteControlPause:
//            print("received remote pause\n")
//            ViewController.sharedInstance.pausePlayer()
//        case UIEvent.EventSubtype.remoteControlTogglePlayPause:
//            print("received toggle\n")
//            //ViewController.sharedInstance.toggle()
//        default:
//            print("received \(event.subtype) which we did not process\n")
//        }
//    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

