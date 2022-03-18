//
//  DataStorage.swift
//  CoreData_demo
//
//  Created by User on 16.03.2022.
//

import Foundation
import CoreData
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    var taskList: [Task] = []
    
    lazy var context = persistentContainer.viewContext
    
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
    
    private init() {}
    
    func fetchData() {
        // Создаем запрос к БД. "Мы хотим получить объекты с типом Task"
        let fetchRequest = Task.fetchRequest()
        
        do {
            //Добавляем в массив данные(тоже массив) из контекста.
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print("Faild to fetch Data", error)
        }
        
    }
    
    func save(_ taskName: String, in tableView: UITableView) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }

        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        // Сохраняем в постоянное хранилище(Persistent Store)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func delete (at index: Int) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            try taskList = context.fetch(fetchRequest)
        } catch let error {
            print("Error: ", error)
        }
        
        let task = taskList[index]
        context.delete(task)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func reSave(at index:Int, and text: String) {
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            try taskList = context.fetch(fetchRequest)
        } catch let error {
            print("Error: ", error)
        }
        let task = taskList[index]
        task.title = text
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
