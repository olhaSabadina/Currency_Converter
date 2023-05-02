//
//  DataManadger.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-01.
//

import Foundation


struct NetworkFetchManager {
    
    func fetchCurrences(date: Date, completionhandler: @escaping (CurrencesModel?)->()){
        guard let url = URL(string: "https://api.privatbank.ua/p24api/exchange_rates?json&date=01.05.2023") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil)
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil)
            }
            
            if let currences = parseJSON(data: data) {
                completionhandler(currences)
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> CurrencesModel? {
        
        let decoder = JSONDecoder()
        
        do{
            let currencesData = try decoder.decode(Exchange.self, from: data)
            guard let currencesModel = CurrencesModel(date: currencesData) else { return nil
            }
            return currencesModel
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}


