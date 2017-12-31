//
//  ContatoDao.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import Foundation
import CoreData


enum Entities {
    case contato
    
    func name() -> String {
        switch self {
        case .contato:
            return "Contato"
        }
    }
}

class ContatoDao {
    static let shared = ContatoDao()
    
    var count: Int {
        
        get {
            return contatos.count
        }
        
    }
    
    private var contatos = [Contato]()
    private let stack = CoreDataStack<Contato>(entity: .contato)
    
    private init(){
        contatos = stack.findAll()
    }
    
    func contatoManaged() -> Contato {
        return stack.newManagedEntity()
    }
    
    
    func findAll() -> [Contato] {
        return contatos
    }
    
    func find(by id:Int) -> Contato?{
        guard id < count else {
            return nil
        }
        
        return contatos[id]
    }
    
    func add(contato: Contato){
        
        if !contatos.contains(contato) {
            contatos.append(contato)
        }
        
        stack.saveContext()
    }
        
    
    func remove(contato: Contato) {
        
        guard let index = index(of: contato)  else {
            return
        }
        
        stack.delete(entity: contato)
        
        contatos.remove(at: index)
    }
    
    func index(of contato: Contato) -> Int? {
        return contatos.index(of: contato)
    }
}



fileprivate class CoreDataStack<T> where T: NSManagedObject {
    
    private let entity: Entities
    
    
    init(entity: Entities) {
        self.entity = entity
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "IP67_Swift4")
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
    
    
    private var context: NSManagedObjectContext {
       return persistentContainer.viewContext
    }
    
    func findAll() -> [T] {
        
        let request = NSFetchRequest<T>(entityName: entity.name())
        
        guard let result = try? context.fetch(request) else {
            fatalError()
        }
        
        return result
    }
    
    
    
    func newManagedEntity() -> T {
        
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entity.name(), into: context) as? T else {
            fatalError()
        }
        
        return entity
    }
    
    
    func delete(entity: T) {
        context.delete(entity)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
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
}
