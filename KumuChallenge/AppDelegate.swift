//
//  AppDelegate.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/24/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataWorker.shared.saveContext()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MoviesViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
}

