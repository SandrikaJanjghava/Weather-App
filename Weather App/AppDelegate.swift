//
//  AppDelegate.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = TabBarViewController.load(withNetwork: Network())
        let navigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController

        self.window?.makeKeyAndVisible()
        
        return true
    }
}

