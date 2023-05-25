//
//  DataManadger.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-01.
//

import Foundation
import CoreData

struct NetworkFetchManager {
    
    lazy var coreData = CoreDataManager.instance
    
    func fetchCurrences(for date: Date, completionhandler: @escaping (Data?, Error?)->(Void)) {
        guard let url = URL(string: "https://api.privatbank.ua/p24api/exchange_rates?json&date=\(date.formateDateToJsonRequest())") else {
            completionhandler(nil, NetworkRequestError.notValidURL)
            return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil, NetworkRequestError.noData)
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil, NetworkRequestError.statusCode)
            }
            
                completionhandler(data, nil)
        }
        task.resume()
    }
    
    func parseCurrency(_ jsonData: Data?, completionhandler: @escaping (CurrenciesModel?)->()) {
        guard let data = jsonData else {
            completionhandler(nil)
            return
        }
        if let currency = parseJSON(data: data) {
            completionhandler(currency)
        }
    }
    
    private func parseJSON(data: Data) -> CurrenciesModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let currenciesData = try decoder.decode(Exchange.self, from: data)
            guard let currenciesModel = CurrenciesModel(date: currenciesData) else { return nil
            }
            return currenciesModel
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}


