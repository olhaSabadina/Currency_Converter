//
//  EnumError.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-16.
//

import Foundation

enum NetworkRequestError: Error {
    case noData
    case statusCode
    case notValidURL
    case parseError
}
