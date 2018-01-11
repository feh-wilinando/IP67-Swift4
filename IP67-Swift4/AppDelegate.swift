//
//  AppDelegate.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let controller = window?.rootViewController else {
            return false
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let items = urlComponents?.queryItems else {
            return true
        }
        
        
        let message = items.map({ "key: \($0.name) - value: \($0.value ?? "none")" }).reduce("", {$0 + "\n" + $1})
        
        let alert = UIAlertController(title: "Open from Schema", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
        
        return true
    }

}

