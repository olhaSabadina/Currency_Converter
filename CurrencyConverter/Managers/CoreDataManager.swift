//
//  CoreDataManager.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-16.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    lazy var context = persistentContainer.viewContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CurrencyConverter")
        persistentContainer.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    init(_ test: String? = nil) {
        persistentContainer = NSPersistentContainer(name: "CurrencyConverter")
        persistentContainer.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
    }
    
    func getJsonCurrencysForDate(date: Date) -> JsonCurrencys? {
        var jsonCurrencys: [JsonCurrencys] = []
        let fetchRequest = NSFetchRequest<JsonCurrencys>(entityName: "JsonCurrencys")
        do{
            jsonCurrencys = try context.fetch(fetchRequest)
        } catch {
            print(CoreDataError.noFetchData)
        }
        
        for item in jsonCurrencys {
            if date.differenceCalculation(date: item.dateFetch!) {
                return item
            }
        }
        return nil
    }
    
    func getCurrencyFromCore() -> [String] {
        var currencyCore: [CurrencyCore] = []
        let fetchRequest = NSFetchRequest<CurrencyCore>(entityName: "CurrencyCore")
        
        let sortDescriptorToIdTime = NSSortDescriptor(key: #keyPath(CurrencyCore.idTime), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorToIdTime]
        
        do{
            currencyCore = try context.fetch(fetchRequest)
        } catch {
            print(CoreDataError.noFetchData)
        }
        
        var array = [String]()
        currencyCore.forEach { item in
            array.append(item.currencyName ?? "")
        }
        return array
    }
    
    func newCurrencyCore(_ currency: Currency) {
        let newCurrencyCore = CurrencyCore(context: context)
        newCurrencyCore.currencyName = currency.currency
        newCurrencyCore.idTime = Date()
        saveContext()
    }
    
    func newCurrencyCoreFromString(_ currencyName: String) {
        let newCurrencyCore = CurrencyCore(context: context)
        newCurrencyCore.currencyName = currencyName
        newCurrencyCore.idTime = Date()
        saveContext()
    }
    
    func newjsonCurrencys(jsonCurrencyData: Data?, date: Date) {
        let newjsonCurrencys = JsonCurrencys(context: context)
        guard let dataJson = jsonCurrencyData else {return}
        newjsonCurrencys.dateFetch = date
        newjsonCurrencys.jsonData = dataJson
        saveContext()
    }
    
    func deleteCurrencyCore(_ indexDelete: Int) {
        let fetchRequest = NSFetchRequest<CurrencyCore>(entityName: "CurrencyCore")
        let sortDescriptorToIdTime = NSSortDescriptor(key: #keyPath(CurrencyCore.idTime), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorToIdTime]
        do{
            let currencyCores = try context.fetch(fetchRequest)
            context.delete(currencyCores[indexDelete])
            saveContext()
        } catch {
            print(CoreDataError.noFetchData)
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
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


