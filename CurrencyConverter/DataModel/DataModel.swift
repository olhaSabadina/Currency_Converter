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
    var baseCurrency: BaseCurrency?
    let currency: String
    var saleRateNB: Double?
    var purchaseRateNB: Double?
    var saleRate: Double?
    var purchaseRate: Double?
    var textFieldDoubleValue: Double?
    
    var fullCurrensyName: String {
    return currency + " - " + (currencesDictionary[currency] ?? "not data")
    }
    
    var firstLetter: String {
        return currency[currency.startIndex].uppercased()
    }
}






