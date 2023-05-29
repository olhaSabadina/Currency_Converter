//
//  TransformCurrency.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-03.
//

import Foundation

struct TransformCurrencyToListArray {
    var headerArray: [String] = []
    var sectionsArray: [[Currency]] = [[]]
    private let popular = ["UAH","EUR","USD"]
    
    mutating func createDataSourceHeaderAndSectionsArray(model: [Currency]){
        var popularArrayCurrencys: [Currency] = []
        
        model.forEach{ value in
            headerArray.append(value.firstLetter)
            if popular.contains(value.currency) {
                popularArrayCurrencys.append(value)
            }
        }
        headerArray = Array(Set(headerArray)).sorted()
        sectionsArray = headerArray.map { firstLet in
            return model
                .filter { $0.firstLetter == firstLet }
                .sorted { $0.currency < $1.currency }
        }
        headerArray.insert("Popular", at: 0)
        sectionsArray.insert(popularArrayCurrencys, at: 0)
    }
}


