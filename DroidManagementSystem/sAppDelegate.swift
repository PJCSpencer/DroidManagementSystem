//
//  sAppDelegate.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 01/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?
    

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let controller = AppController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

