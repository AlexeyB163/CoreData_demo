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
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    //persistentContainer - точка входа в базу данных
    private let persistentContainer: NSPersistentContainer = {
        
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
    
    
    // ПРИ РАБОТЕ С БД НУЖНО ИСПОЛЬЗОВАТЬ COMPLETION{}, чтобы можно было получать данные асинхронно и не было задержек между запросом к БД и получением результата.
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        // Создаем запрос к БД. "Мы хотим получить объекты с типом Task"
        let fetchRequest = Task.fetchRequest()
        
        do {
            //Получаем данные(массив) из контекста.
            let tasks = try context.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }

        task.title = taskName
        completion(task)
        // Сохраняем в постоянное хранилище(Persistent Store)
        saveContext()
    }
    
    func reSave (_ task: Task, newTask: String) {
        
        task.title = newTask
        saveContext()
    }
    
    func delete(_ task: Task) {
        
        context.delete(task)
        saveContext()
    }
    
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
