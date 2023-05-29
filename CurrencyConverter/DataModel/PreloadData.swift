//
//  PreloadData.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-23.
//

import Foundation


struct PreloadData {
    
    let preloadDataKey = "PreloadDataKey"
    let coreDataManager = CoreDataManager.instance
    let userDefaults = UserDefaults.standard
    let namesCurrency = ["UAH", "USD", "EUR"]

    func addDefaultCurrenciesToCoreData(){
        if !userDefaults.bool(forKey: preloadDataKey) {
            let backgroundContext = coreDataManager.persistentContainer.newBackgroundContext()
            coreDataManager.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                do {
                    namesCurrency.forEach { name in
                        coreDataManager.newCurrencyCoreFromString(name)
                    }
                    try backgroundContext.save()
                    userDefaults.set(true, forKey: preloadDataKey)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


