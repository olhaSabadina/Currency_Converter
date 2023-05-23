//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-05-23.
//

import Foundation

extension String {

    func onlyDigits() -> Bool {
        let regularExpression = "^([0-9]*)+([.]?)+([0-9]*)$"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
}
