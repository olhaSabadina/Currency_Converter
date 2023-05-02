//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-30.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    var currencyArrayFromNet = [Currency]()
    var tableCurrences = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupTable()
        print(currencyArrayFromNet.count, "массив валют с нета")
    }
    
    func setView() {
        view.backgroundColor = .white
        title = "Currences List"
    }
    
    func setupTable() {
        tableCurrences = UITableView(frame: view.bounds, style: .insetGrouped)
        tableCurrences.delegate = self
        tableCurrences.dataSource = self
        view.addSubview(tableCurrences)
        tableCurrences.register(CurrencyListCell.self, forCellReuseIdentifier: CurrencyListCell.cellID)
        
    }
}


//MARK: - Delegates:
extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArrayFromNet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListCell.cellID, for: indexPath) as? CurrencyListCell else {return UITableViewCell()}
        cell.setLabel(currency: currencyArrayFromNet[indexPath.row])
        
        return cell
        
    }
    
    
    
}
