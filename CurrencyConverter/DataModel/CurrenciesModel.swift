//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-01.
//

import Foundation

struct CurrenciesModel {
    let date : String
    let currences: [Currency]
    
    init?(date: Exchange) {
        self.date = date.date
        self.currences = date.exchangeRate
    }
}
