//
//  DataModel.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-01.
//

import Foundation

// MARK: - Exchange
struct Exchange: Codable {
    let date, bank: String
    let baseCurrency: Int
    let baseCurrencyLit: BaseCurrency
    let exchangeRate: [Currency]
}

enum BaseCurrency: String, Codable {
    case uah = "UAH"
}

// MARK: - ExchangeRate
struct Currency: Codable {
    let baseCurrency: BaseCurrency
    let currency: String
    let saleRateNB: Double?
    let purchaseRateNB: Double?
    let saleRate: Double?
    let purchaseRate: Double?
    
    var fullCurrensyName: String {
    return currency + " - " + (currencesDictionary[currency] ?? "not data")
    }
    
    var firstLetter: String {
        return currency[currency.startIndex].uppercased()
    }
}






