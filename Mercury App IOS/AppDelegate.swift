//
//  AppDelegate.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/6/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //let dataStack:DATAStack = DATAStack(modelName:"Mercury App IOS")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.sharedManager().enable = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        IQKeyboardManager.sharedManager().toolbarPreviousNextAllowedClasses.append(IQKeyboardViewContainer.self)
        
        var initialViewController = storyboard.instantiateViewController(withIdentifier: "RegistrationVC")
        if isKeyPresent(key: "username") == true {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //print("\(urls[urls.count-1] as URL)")
        
        return true
    }
    
    func isKeyPresent(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Mercury App IOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:  CoreData Helper
    lazy var parentContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return moc
    }()
    
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        moc.parent = self.parentContext
        return moc
    }()
    
    func save(moc:NSManagedObjectContext) {
        
        moc.performAndWait {
            
            if moc.hasChanges {
                
                do {
                    try moc.save()
                } catch {
                    //print("ERROR saving context \(moc.description) - \(error)")
                }
            }
            
            if let parentContext = moc.parent {
                self.save(moc: parentContext)
            }
        }
    }
    
    func save() {
        
        self.context.performAndWait {
            
            if self.context.hasChanges {
                
                do {
                    try self.context.save()
                } catch {
                    //print("ERROR saving context \(self.context.description) - \(error)")
                }
            }
            
            if let parentContext = self.context.parent {
                self.save(moc: parentContext)
            }
        }
    }
            
}

