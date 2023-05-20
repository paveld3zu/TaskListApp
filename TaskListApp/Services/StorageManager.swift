//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Pavel Karunnyj on 20.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
            return taskList
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(_ taskName: String) -> Task {
        let task = Task(context: viewContext)
        task.title = taskName
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                return task
            } catch {
                print(error.localizedDescription)
            }
        }
        return task
    }
    
    func delete(_ taskName: Task) {
        viewContext.delete(taskName)
        saveContext()
        }
}
