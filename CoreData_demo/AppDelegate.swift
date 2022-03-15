//
//  AppDelegate.swift
//  CoreData_demo
//
//  Created by User on 14.03.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    }

    // Метод вызывается при выгрузке приложения из памяти
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    // MARK: - Core Data stack

    //persistentContainer - точка входа в базу данных
    lazy var persistentContainer: NSPersistentContainer = {
       // (name:____) - указывается название файла в котором будет находится модель с данными
        let container = NSPersistentContainer(name: "CoreData_demo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    // Метод проверяет были ли внесены какие либо изменения во временной области памяти
    // Если изменения были, то эти изменения нужно перенести из оперативной памяти в постоянное хранилище
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

