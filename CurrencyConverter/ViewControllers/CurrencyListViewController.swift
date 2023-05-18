//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Olya Sabadina on 2023-04-30.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    static let cellID = "currencyCell"
    
    var currencyArrayFromNet: [Currency]?
    var completionChooseCurrency: ((Currency)->())?
    
    var tableCurrences = UITableView()
    let searchController = UISearchController()
    var transformCur = TransformCurrency()
    var filteredDataToSections: [Currency] = []
    var arrayCurrencyForTableWithSection: [[Currency]] = []
    var headerTitlesArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupTable()
        setupLeftBarButton()
        setupSearchController()
        transformArrayForTableWithSections(model: currencyArrayFromNet)
        print(currencyArrayFromNet?.count, "массив валют с нета")
    }
    
    @objc func back(){
        dismiss(animated: true)
    }
    
    func setView() {
        view.backgroundColor = .secondarySystemBackground
        title = "Currencies List"
    }
    
    func setupTable() {
        tableCurrences = UITableView(frame: view.bounds, style: .insetGrouped)
        tableCurrences.delegate = self
        tableCurrences.dataSource = self
        view.addSubview(tableCurrences)
        tableCurrences.register(CurrencyListCell.self, forCellReuseIdentifier: CurrencyListViewController.cellID)
        
        tableCurrences.backgroundColor = .clear
        tableCurrences.layer.shadowColor = UIColor.black.cgColor
        tableCurrences.layer.shadowOffset = .init(width: 0, height: 3)
        tableCurrences.layer.shadowRadius = 1
        tableCurrences.layer.shadowOpacity = 0.3
    }
    
    private func setupLeftBarButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Currency", for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    func transformArrayForTableWithSections(model: [Currency]?) {
        
        guard let models = model else {return}
        self.transformCur.createDataSourceHeaderAndSectionsArray(model: models)
        self.headerTitlesArray = self.transformCur.headerArray
        self.arrayCurrencyForTableWithSection = self.transformCur.sectionsArray
            DispatchQueue.main.async {
                self.tableCurrences.reloadData()
            }
    }
}


//MARK: - Table Delegate DataSource:
extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currency: Currency!
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = filteredDataToSections[indexPath.row]
            dismiss(animated: false)
        } else {
            currency = arrayCurrencyForTableWithSection[indexPath.section][indexPath.row]
        }
        completionChooseCurrency?(currency)
        back()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return arrayCurrencyForTableWithSection.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDataToSections.count
        }
        return arrayCurrencyForTableWithSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListViewController.cellID, for: indexPath) as? CurrencyListCell else {return UITableViewCell()}
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.setLabel(currency: filteredDataToSections[indexPath.row])
        } else {
            cell.setLabel(currency: arrayCurrencyForTableWithSection[indexPath.section][indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Find:"
        }
        return headerTitlesArray?[section]
    }
    
}

//MARK: - Search Controller Configuration

extension CurrencyListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        guard let currencies = currencyArrayFromNet else {return}
        filteredDataToSections = currencies.filter({$0.fullCurrensyName.lowercased().contains(searchText.lowercased())})
        tableCurrences.reloadData()
    }
    
}
