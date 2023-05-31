//
//  CurrencyNetworkTest.swift
//  CurrencyConverterTests
//
//  Created by Olya Sabadina on 2023-05-31.
//

import XCTest
@testable import CurrencyConverter


final class CurrencyNetworkTest: XCTestCase {
    
    var networkManager: NetworkFetchManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkFetchManager()
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
    }
    
    func testFetchCurrencyData()  {
        let expectation = expectation(description: "Currency data fetch from server")
        
        networkManager.fetchCurrences(for: Date()) { data, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testParseCurrencyDataToCurrencyModel() {
           let expectation = expectation(description: "Parse Json data to CurrencyModel ")
           var currencyData: Data?
           var currencyModels: CurrenciesModel?

        networkManager.fetchCurrences(for: Date()) { data, error in
               if let error = error {
                   XCTFail("Error: \(error.localizedDescription)")
                   return
               }
               currencyData = data
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 10)
           XCTAssertNotNil(currencyData)

           networkManager.parseCurrency(currencyData) { currencyModel in
               guard currencyModel != nil else {
                   XCTAssertNil(currencyModel)
                   return
               }
               currencyModels = currencyModel
               XCTAssertNotNil(currencyModels)
           }

        XCTAssertTrue((currencyModels?.currences.count)! > 10)
        XCTAssertFalse(currencyModels?.currences.count == 0)
       }
    
}
